# include <stdio.h>
# include <cs50.h>
# include <string.h>
# include <ctype.h>

int main(int argc, string argv[])
{
    /*validating command-line arguements*/
    if (argc == 2)
    {
        for (int i = 0; i < strlen(argv[1]); i++)
        {
            for (int j = 0; j < strlen(argv[1]); j++)
            {
                if (isalpha(argv[1][i]) == 0 || (i != j && argv[1][i] == argv[1][j]))
                {
                    printf("Usage: %s key\n", argv[0]);
                    return 1;
                }
            }
        }

        if (strlen(argv[1]) != 26)
        {
            printf("Key must contain 26 characters.\n");
            return 1;
        }
    }
    else
    {
        printf("Usage: %s key\n", argv[0]);
        return 1;
    }


    /*encryption*/
    string key = argv[1];
    string txt = get_string("plaintext: ");
    for (int i = 0; i < strlen(txt); i++)
    {
        /*uppercase*/
        if (txt[i] >= 'A' && txt[i] <= 'Z')
        {
            txt[i] -= 65;
            txt[i] = toupper(key[(int)txt[i]]);
        }

        /*lowercase*/
        else if (txt[i] >= 'a' && txt[i] <= 'z')
        {
            txt[i] -= 97;
            txt[i] = tolower(key[(int)txt[i]]);
        }
    }


    /*return string*/
    printf("ciphertext: %s\n", txt);

}
