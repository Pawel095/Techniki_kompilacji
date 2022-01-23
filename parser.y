%define parse.error detailed 


%{
    // REMLAT: disable debug
    bool ENABLEDP=true;
    const char* ENTRYPOINT_NAME = "entrypoint";
%}

%code requires{
    #include "global.hpp"
    #include "debug/printer.hpp"
    #include "asmfor/asmfor.hpp"
}

%union{
    std::vector<int>* symtable_index_v;
    int symtable_index;
    RELOP relop;
    STD_TYPES std_type;
    TypeAllocator type_allocator;
    SIGN sign;
    MULOP mulop;
}

%token program_t
%token var_t
%token integer_t
%token real_t
%token array_t
%token begin_t
%token end_t
%token of_t
%token function_t
%token procedure_t
%token array_range_t

%token <symtable_index> ident_t
%token <symtable_index> num_t

%token while_t
%token do_t

%token if_t
%token else_t
%token then_t

%token write_t
%token read_t

%token assign_op_t
%token <relop> relop_t
%token <sign> sign_t
%token <mulop> mulop_t
%token or_t
%token not_t


%type <std_type> standard_type
%type <type_allocator> type
%type <symtable_index> factor
%type <symtable_index> term
%type <symtable_index> simple_expression
%type <symtable_index> expression
%type <symtable_index_v> expression_list
%type <symtable_index> variable
%type <symtable_index_v> identifier_list
%type <symtable_index_v> parameter_list
%type <symtable_index_v> arguments
%type <symtable_index> subprogram_head

%destructor {delete $$;} <symtable_index_v>

%%

program:
    program_t ident_t '(' identifier_list ')' ';'
    {
        std::string msg = std::string("nazwa programu: ") + std::string(memory[$2].name_or_value);
        print_if_debug(msg,"program",ENABLEDP);
        memory<<std::string("jump.i #")+ENTRYPOINT_NAME + "\n";
        delete $4;
    }
    declarations 
    {
        memory.set_scope(SCOPE::LOCAL);
        print_if_debug("Scope set to local","program->declarations",ENABLEDP);
    }
    subprogram_declarations
    {
        memory.set_scope(SCOPE::GLOBAL);
        print_if_debug("Scope set to global","program->subprogram_declarations",ENABLEDP);
        // TODO: kod z funkcji :: close.
        memory<<std::string(ENTRYPOINT_NAME) + ":" + "\n";
    }
    compound_statement '.'
    {
        memory<<std::string("exit\n");
    }
;
identifier_list:
    ident_t
    {
        $$ = new std::vector<int>();
        $$->push_back($1);
        print_if_debug(memory[$1].name_or_value,"identifier_list[0]->ident_t",ENABLEDP);
    }
    | identifier_list ',' ident_t
    {
        $$->push_back($3);
        print_if_debug(*$1,"identifier_list[1]->identifier_list",ENABLEDP);
        print_if_debug(memory[$3].name_or_value,"identifier_list[1]->ident_t",ENABLEDP);
    }
;
declarations:
    declarations var_t identifier_list ':' type ';'
    {
        for (auto index : *$3)
        {
            auto entry = memory[index];
            if (memory.get_scope()==SCOPE::GLOBAL)
                entry.type=ENTRY_TYPES::VAR;
            else
                entry.type = ENTRY_TYPES::LOCAL_VAR;
            entry.vartype=$5.type;
            memory.update_entry(index,entry);
            memory.allocate(index);
        }
        delete $3;
    }
    | %empty
;
type:
    standard_type
    {
        $$ = TypeAllocator();
        $$.type = $1;
    }
    | array_t '[' num_t array_range_t num_t ']' of_t standard_type
    {
        // TODO: array type
    }
;
standard_type:
    integer_t {$$ = STD_TYPES::INTEGER;}
    | real_t {$$ = STD_TYPES::REAL;}
;
subprogram_declarations:
    subprogram_declarations subprogram_declaration ';'
    | %empty
;
subprogram_declaration:
    subprogram_head declarations compound_statement
    {
        std::cout<<memory.dump().c_str()<<std::endl;
        memory<<std::string("leave\nreturn\n");

        outfile<<memory[$1].name_or_value<<":"<<std::endl;
        outfile<<"enter.i #"<< memory.local_temp_bytes()<<std::endl;
        outfile<<memory.func_body();
        
        memory.reset_scope();
        print_if_debug("Scope reset","subprogram_declaration",ENABLEDP);
    }
;
subprogram_head:
    function_t ident_t arguments ':' standard_type ';'
    {
        memory.initial_bp(false);
        auto func = memory[$2];
        func.type=ENTRY_TYPES::FUNC;
        func.vartype=$5;
        memory.update_entry($2,func);
        memory.allocate($2);
        func = memory[$2];
        // add args to symtable, update func argtypes.
        while (! $3->empty()){
            int id = $3->back();
            $3->pop_back();
            auto arg = memory[id];

            func.arg_types.insert(func.arg_types.begin(),arg.vartype);
            arg.type = ENTRY_TYPES::ARGUMENT;
            memory.update_entry(id,arg);
            memory.allocate(id);
        }
        memory.update_entry($2,func);
        memory.current_function = func;
        // add return value to symtable
        delete $3;
        $$ = $2;
    }
    | procedure_t ident_t arguments ';'
    {
        memory.initial_bp(false);
        auto func = memory[$2];
        func.type=ENTRY_TYPES::PROCEDURE;
        // add args to symtable, update func argtypes.
        while (! $3->empty()){
            int id = $3->back();
            $3->pop_back();
            auto arg = memory[id];

            func.arg_types.insert(func.arg_types.begin(),arg.vartype);
            arg.type = ENTRY_TYPES::ARGUMENT;
            memory.update_entry(id,arg);
            memory.allocate(id);
        }
        memory.update_entry($2,func);
        delete $3;
        $$ = $2;
    }
;
arguments:
    '(' parameter_list ')'
    {
        $$ = $2;
    }
    | %empty
    {
        $$ = new std::vector<int>();
    }
;
parameter_list:
    identifier_list ':' type
    {
        print_if_debug(*$1,"parameter_list[0]->identifier_list",ENABLEDP);
        for (auto id:*$1) {
            auto entry = memory[id];
            entry.vartype = $3.type;
            memory.update_entry(id,entry);
        }
        $$ = $1;
    }
    | parameter_list ';' identifier_list ':' type
    {
        print_if_debug(*$1,"parameter_list[1]->parameter_list",ENABLEDP);
        print_if_debug(*$3,"parameter_list[1]->identifier_list",ENABLEDP);
        for (auto index:*$3) {
            $$->push_back(index);
            auto entry = memory[index];
            entry.vartype = $5.type;
            memory.update_entry(index,entry);
        }
        delete $3;
    }
;
compound_statement: 
    begin_t
    optional_statements
    end_t
;
optional_statements: 
    statement_list
    | %empty
;
statement_list:
    statement
    | statement_list ';' statement
;
statement: 
    variable assign_op_t expression
    {
        print_if_debug(std::to_string($1),"statement[0]->variable",ENABLEDP);
        print_if_debug(std::to_string($3),"statement[0]->expression",ENABLEDP);
        auto var = memory[$1];
        auto expr = memory[$3];
        if (var.vartype != expr.vartype) {
            auto converted = memory.add_temp_var(var.vartype);
            if(var.vartype == STD_TYPES::INTEGER){
                memory<<asmfor_op2args(std::string("realtoint"), expr, converted);
            }
            if (var.vartype == STD_TYPES::REAL) {
                memory<<asmfor_op2args(std::string("inttoreal"), expr, converted);
            }
            memory<<asmfor_op2args(std::string("mov"), converted, var);
        }else{
            memory<<asmfor_op2args(std::string("mov"), expr, var);
        }
    }
    | procedure_statement
    | compound_statement
    | if_t expression 
    {
        print_if_debug("IF","statement[3]->expr",ENABLEDP);
        auto else_l = memory.make_label();
        auto end_l = memory.make_label();
        // TODO: push labels to the label stack (else_l, end_l)
        memory.if_label_stack.push_back(else_l);
        memory.if_label_stack.push_back(end_l);
        // TODO: check expression, then jump to the else_l.
        Entry false_ = Entry();
        false_.type = ENTRY_TYPES::CONST;
        false_.name_or_value = std::string("0");
        false_.vartype = STD_TYPES::INTEGER;

        memory<<asmfor_op3args(std::string("je"), memory[$2], false_, else_l);
    }
    then_t statement
    {
        // get end_l from label stack
        auto end_l = memory.if_label_stack.back();
        // TODO: insert jump to the end_l
        memory<<std::string("jump.i ")+end_l.get_asm_var()+"\n";
    }
    else_t
    {
        auto else_l = memory.if_label_stack[memory.if_label_stack.size()-2];
        memory<<else_l.get_asm_ptr() +"\n";
    }
    statement
    {
        // TODO: insert end label and pop the label
        auto end_l = memory.if_label_stack.back();

        memory<<end_l.get_asm_ptr() +"\n";
        memory.if_label_stack.pop_back();
        memory.if_label_stack.pop_back();
    }
    | while_t expression do_t statement
    | write_t '(' expression_list ')'
    {
        memory<<asmfor_op1arg_v(std::string("write"),*$3);
        delete $3;
    }
;
variable:
    ident_t
    {
        print_if_debug(memory[$1].name_or_value,"variable[0]->ident_t",ENABLEDP);
        auto ident = memory[$1];
        if (ident.type==ENTRY_TYPES::FUNC){
            if (memory.get_scope() == SCOPE::LOCAL &&memory.current_function.name_or_value == ident.name_or_value){
                print_if_debug(memory[$1].name_or_value + " is actually a return statement.","variable[0]->ident_t",ENABLEDP);    
            }else{
                print_if_debug(memory[$1].name_or_value + " is actually a function. execute, pass result up.","variable[0]->ident_t",ENABLEDP);
                auto temp = memory.add_temp_var(ident.vartype);
                memory<<std::string("push.i ") + temp.get_asm_ptr()+"\n";
                memory<<std::string("call.i #")+memory[$1].name_or_value+"\n";
                memory<<std::string("incsp.i #4\n");
                $$ = temp.mem_index;
            }
        }else{
            // var or const.
            $$ = $1;
        }
    }
    | ident_t '[' expression ']' // TODO: array access
    {
    }
;
procedure_statement:
    ident_t
    {
        // standalone call without arguments
        // func;
        print_if_debug(memory[$1].name_or_value,"procedure_statement[0]->ident_t",ENABLEDP);
        memory<<std::string("call.i #")+memory[$1].name_or_value+"\n";
    }
    | ident_t '(' expression_list ')'
    {
        // standalone call with arguments
        // func(a,2);
        print_if_debug(memory[$1].name_or_value,"procedure_statement[1]->ident_t",ENABLEDP);
        print_if_debug(*$3,"procedure_statement[1]->expression_list",ENABLEDP);
        auto func = memory[$1];
        for(size_t i=0;i< $3->size();i++) {
            int id = $3->at(i);
            STD_TYPES funcargtype = func.arg_types[i];
            Entry arg = memory[id];

            // convert first, then check if const.
            if (arg.vartype!=funcargtype) {
                Entry temp = memory.add_temp_var(funcargtype);
                if (funcargtype == STD_TYPES::REAL)
                    memory<<asmfor_op2args(std::string("inttoreal"), arg, temp);
                if (funcargtype == STD_TYPES::INTEGER)
                    memory<<asmfor_op2args(std::string("realtoint"), arg, temp);
                arg = temp;
            }

            if (arg.type==ENTRY_TYPES::CONST){
                Entry temp = memory.add_temp_var(arg.vartype);
                memory<<asmfor_op2args(std::string("mov"), arg, temp);
                arg = temp;
            }
            
            if (arg.type == ENTRY_TYPES::VAR || arg.type == ENTRY_TYPES::LOCAL_VAR || arg.type == ENTRY_TYPES::ARGUMENT){
                memory<<std::string("push.i ") + arg.get_asm_ptr()+"\n";
            }else{
                BREAKPOINT;
            }
        }
        memory<<std::string("call.i #") + func.name_or_value+"\n";
        memory<<std::string("incsp.i #") + std::to_string($3->size() * 4) +"\n";
        delete $3;
    }
;
expression_list:
    expression
    {
        $$ = new std::vector<int>();
        $$->push_back($1);
    }
    | expression_list ',' expression {
        print_if_debug(*$1,"expression_list[1]->expression_list",ENABLEDP);
        $$->push_back($3);
    }
;
expression:
    simple_expression
    {
        $$=$1;
    }
    | simple_expression relop_t simple_expression
    {
        auto left = memory[$1];
        auto right = memory[$3];
        RELOP relop = $2;
        auto result = memory.add_temp_var(STD_TYPES::INTEGER);

        switch(relop){
            case RELOP::EQUAL:
                memory<<asmfor_relop(std::string("je"),left,right,result);
                break;
            case RELOP::NOTEQUAL:
                memory<<asmfor_relop(std::string("jne"),left,right,result);
                break;
            case RELOP::LESS:
                memory<<asmfor_relop(std::string("jl"),left,right,result);
                break;
            case RELOP::LESSEQ:
                memory<<asmfor_relop(std::string("jle"),left,right,result);
                break;
            case RELOP::MORE:
                memory<<asmfor_relop(std::string("jg"),left,right,result);
                break;
            case RELOP::MOREEQ:
                memory<<asmfor_relop(std::string("jge"),left,right,result);
                break;
            default:
                break;
        }
        $$ = result.mem_index;
    }
;
simple_expression:
    term
    {
        $$ = $1;
    }
    | sign_t term
    {
        print_if_debug(std::string(enum2str($1)),"simple_expresson[1]->sign",ENABLEDP);
        $$ = $2;
        if ($1 == SIGN::MINUS){
            auto term = memory[$2];
            auto temp = memory.add_temp_var(term.vartype);
            auto zero = Entry();
            zero.type=ENTRY_TYPES::CONST;
            zero.name_or_value=std::string("0");
            zero.vartype=term.vartype;
            
            memory<<asmfor_op3args(std::string("sub"), zero, term, temp);
            $$ = temp.mem_index;
        }
    }
    | simple_expression sign_t term
    {
        auto expr = memory[$1];
        auto term = memory[$3];
        // upgrade vars to real if needed
        if (expr.vartype != term.vartype) {
            auto upgraded = memory.add_temp_var(STD_TYPES::REAL);
            if (expr.vartype != STD_TYPES::REAL) {
                memory<<asmfor_op2args(std::string("inttoreal"), expr, upgraded);
                expr = upgraded;
            }
            if (term.vartype != STD_TYPES::REAL) {
                memory<<asmfor_op2args(std::string("inttoreal"), term, upgraded);
                term = upgraded;
            }
        }
        // all vars have the same type here.
        auto tempvar = memory.add_temp_var(expr.vartype);

        switch($2){
            case SIGN::PLUS:
                memory<<asmfor_op3args(std::string("add"), expr, term, tempvar);
                break;
            case SIGN::MINUS:
                memory<<asmfor_op3args(std::string("sub"), expr, term, tempvar);
                break;
        }
        $$ = tempvar.mem_index;
    }
    | simple_expression or_t term
    {
        print_if_debug(std::to_string($1),"simple_expression[3]->simple_expression",ENABLEDP);
        print_if_debug(std::string("or"),"simple_expression[3]",ENABLEDP);
        print_if_debug(std::to_string($3),"simple_expression[3]->term",ENABLEDP);

        auto expr = memory[$1];
        auto term = memory[$3];
        
        if (expr.vartype != STD_TYPES::INTEGER) {
            auto upgraded = memory.add_temp_var(STD_TYPES::INTEGER);
            memory<<asmfor_op2args(std::string("realtoint"), expr, upgraded);
            expr = upgraded;
        }
        if (term.vartype != STD_TYPES::INTEGER) {
            auto upgraded = memory.add_temp_var(STD_TYPES::INTEGER);
            memory<<asmfor_op2args(std::string("realtoint"), term, upgraded);
            term = upgraded;
        }
        // all vars have the same type here.
        auto tempvar = memory.add_temp_var(STD_TYPES::INTEGER);
        memory<<asmfor_op3args(std::string("add"), expr, term, tempvar);
    }
;
term:
    factor
    {
        print_if_debug(std::to_string($1),"term->factor",ENABLEDP);
        $$=$1;
    }
    | term mulop_t factor
    {
        print_if_debug(std::to_string($1),"term[1]->term",ENABLEDP);
        print_if_debug(std::string("Mulop: ")+enum2str($2),"term[1]->mulop",ENABLEDP);
        print_if_debug(std::to_string($3),"term[1]->factor",ENABLEDP);
        
        auto term = memory[$1];
        auto factor = memory[$3];
        // upgrade vars to real if needed
        if (term.vartype != factor.vartype) {
            auto upgraded = memory.add_temp_var(STD_TYPES::REAL);
            if (term.vartype != STD_TYPES::REAL) {
                memory<<asmfor_op2args(std::string("inttoreal"), term, upgraded);
                term = upgraded;
            }
            if (factor.vartype != STD_TYPES::REAL) {
                memory<<asmfor_op2args(std::string("inttoreal"), factor, upgraded);
                factor = upgraded;
            }
        }
        // both real or both int.
        auto tempvar = memory.add_temp_var(term.vartype);
        switch($2){
            case MULOP::STAR:
                memory<<asmfor_op3args(std::string("mul"), term, factor, tempvar);
                break;
            case MULOP::SLASH:
            case MULOP::DIV:
                memory<<asmfor_op3args(std::string("div"), term, factor, tempvar);
                break;
            case MULOP::MOD:
                memory<<asmfor_op3args(std::string("mod"), term, factor, tempvar);
                break;
            case MULOP::AND:
                memory<<asmfor_op3args(std::string("mul"), term, factor, tempvar);
                break;
            default:
                break;
        }
        $$ = tempvar.mem_index;
    }
;
factor:
    variable
    {
        print_if_debug(std::to_string($1), "factor[0]->variable", ENABLEDP);
        $$ = $1;
    }
    | ident_t '(' expression_list ')' // Function call with assign later.
    {
        // assign call with arguments
        // func(a,2);
        print_if_debug(memory[$1].name_or_value,"factor[1]->ident_t",ENABLEDP);
        print_if_debug(*$3,"factor[1]->expression_list",ENABLEDP);
        auto func = memory[$1];
        if (func.type!=ENTRY_TYPES::FUNC){
            // TODO: some error message?
            BREAKPOINT;
        }

        for(size_t i=0;i< $3->size();i++) {
            int id = $3->at(i);
            STD_TYPES funcargtype = func.arg_types[i];
            Entry arg = memory[id];

            // convert first, then check if const.
            if (arg.vartype!=funcargtype) {
                Entry temp = memory.add_temp_var(funcargtype);
                if (funcargtype == STD_TYPES::REAL)
                    memory<<asmfor_op2args(std::string("inttoreal"), arg, temp);
                if (funcargtype == STD_TYPES::INTEGER)
                    memory<<asmfor_op2args(std::string("realtoint"), arg, temp);
                arg = temp;
            }

            if (arg.type==ENTRY_TYPES::CONST){
                Entry temp = memory.add_temp_var(arg.vartype);
                memory<<asmfor_op2args(std::string("mov"), arg, temp);
                arg = temp;
            }
            
            if (arg.type == ENTRY_TYPES::VAR || arg.type == ENTRY_TYPES::LOCAL_VAR || arg.type == ENTRY_TYPES::ARGUMENT){
                memory<<std::string("push.i ") + arg.get_asm_ptr()+"\n";
            }else{
                BREAKPOINT;
            }
        }
        auto return_value = memory.add_temp_var(func.vartype);
        memory<<std::string("push.i ") + return_value.get_asm_ptr()+"\n";
        memory<<std::string("call.i #") + func.name_or_value+"\n";
        memory<<std::string("incsp.i #") + std::to_string($3->size() * 4) +"\n";
        delete $3;
        $$ = return_value.mem_index;
    }
    | num_t // a number
    {
        $$ = $1;
    }
    | '(' expression ')' // 'do this first'
    {
        $$ = $2;
    }
    | not_t factor
    {
        auto factor = memory[$2];
        Entry zero = Entry();
        zero.type = ENTRY_TYPES::CONST;
        zero.name_or_value = std::string("0");
        zero.vartype = STD_TYPES::INTEGER;
        Entry result = memory.add_temp_var(STD_TYPES::INTEGER);

        print_if_debug("not "+std::to_string($2),"factor[4]->factor",ENABLEDP);
        memory<<asmfor_relop(std::string("je"),factor,zero,result);
        $$ = result.mem_index;
    }
;
%%
