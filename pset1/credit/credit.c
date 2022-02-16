# include <stdio.h>
# include <cs50.h>
# include <string.h>

int main(void)
{
    /*prompt input*/
    long cc_num;
    do
    {
        cc_num = get_long("Number:");
    }
    while (false);

    char str[50];
    sprintf(str, "%li", cc_num);
    int tot = 0;
    int len = strlen(str);
    long num;
    
    /*Luhn's Algorithm*/
    for (int i = 0; i < len; i++)
    {
        num = cc_num % 10;
        cc_num /= 10;
        if (i % 2 != 0)
        {
            if (num * 2 >= 9)
            {
                tot = tot + (num * 2 / 10) + (num * 2 % 10);
            }
            else
            {
                tot += num * 2;
            }
        }
        else
        {
            tot += num;
        }
    }

    /*differentiate and validate card*/
    if (tot % 10 == 0)
    {
        if (len == 15 && str[0] == '3' && (str[1] == '4' || str[1] == '7'))
        {
            printf("AMEX\n");
        }

        else if (len == 16 && str[0] == '5' && (str[1] == '1' || str[1] == '2' || str[1] == '3' || str[1] == '4' || str[1] == '5'))
        {
            printf("MASTERCARD\n");
        }

        else if (len >= 13 && str[0] == '4')
        {
            printf("VISA\n");
        }

        else
        {
            printf("INVALID\n");
        }
    }
    else
    {
        printf("INVALID\n");
    }
}