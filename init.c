#include "global.h"
struct entry keywords[] = {
    {0, 0}};
void init()
{
  struct entry *p;
  for (p = keywords; p->token; p++)
    insert(p->lexptr, p->token);
}
