#include <stdio.h>
#include <cs50.h>

int main(void)
{
    /*initialize input*/
    double init_val;
    do
    {
        init_val = get_double("Change owed: ");
    }
    while (init_val < 0);
    
    /*quarters*/
    int val = init_val * 100;
    int tot = val / 25;
    val %= 25;
    
    /*dimes*/
    tot += val / 10;
    val %= 10;
    
    /*nickels*/
    tot += val / 5;
    
    /*pennies*/
    tot += val % 5;
    
    printf("%i\n", tot);
}