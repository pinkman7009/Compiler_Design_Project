#include <stdio.h>
#include <stdlib.h>  /* For exit() function */

#define SIZE 200 
char s[SIZE];   

int writeLine(char *s)
{
   FILE *fptr;

   fptr = fopen("program.txt", "a");
   if(fptr == NULL)
   {
      printf("Error opening output file");
      return 0;
   }

   fprintf(fptr,"%s\n", s);
   fclose(fptr);

   return 1;
}
