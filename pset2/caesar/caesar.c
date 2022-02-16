# include <stdio.h>
# include <cs50.h>
# include <string.h>
# include <stdlib.h>
# include <ctype.h>

int main(int argc, string argv[])
{
    /*validating command-line arguements*/
    if (argc == 2 && ((argv[1][0] >= '0' && argv[1][0] <= '9') || argv[1][0] == '-'))
    {
        for (int i = 1; i < strlen(argv[1]);; i++)
        {
            if (isdigit(argv[1][i]) == 0)
            {
                printf("Usage: %s key\n", argv[0]);
                return 1;
            }
        }

    }
    else
    {
        printf("Usage: %s key\n", argv[0]);
        return 1;
    }

    /*calibrate key*/
    int key = atoi(argv[1]);
    if (key > 26)
    {
        key %= 26;
    }


    /*encryption*/
    string txt = get_string("plaintext: ");
    for (int i = 0; i < strlen(txt); i++)
    {
        /*capital letters*/
        if (txt[i] >= 'A' && txt[i] <= 'Z')
        {
            if (txt[i] + key > 'Z')
            {
                txt[i] = txt[i] + key - 26;
            }
            else
            {
                txt[i] += key;
            }
        }

        /*small letters*/
        else if (txt[i] >= 'a' && txt[i] <= 'z')
        {
            if (txt[i] + key > 'z')
            {
                txt[i] = txt[i] + key - 26;
            }
            else
            {
                txt[i] += key;
            }
        }

        /*ignore everything else*/
    }

    /*return output*/
    printf("ciphertext: %s\n", txt);
}
