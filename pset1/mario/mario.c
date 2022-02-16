#include <stdio.h>
#include <cs50.h>

int main(void)
{
    /*input height */
    int ht;
    do
    {
        ht = get_int("Height: ");
    }
    while (ht < 1 || ht > 8);

    /*build layers by width in order: blank-hash-2spaces-hash*/
    for (int wd = 1; wd <= ht; wd++)
    {
        /*blanks*/
        for (int b = 0; b < (ht - wd); b++)
        {
            printf(" ");
        }

        /*hashes*/
        for (int h = 0; h < wd; h++)
        {
            printf("#");
        }

        /*for mario easy skip to line 40*/

        /*2spaces*/
        printf("  ");

        /*hashes*/
        for (int h = 0; h < wd; h++)
        {
            printf("#");
        }



        /*next line*/
        printf("\n");
    }
}