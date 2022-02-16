# include <stdio.h>
# include <cs50.h>
# include <string.h>
# include <ctype.h>
# include <math.h>

int main(void)
{
    /*input text*/
    string input = get_string("Text: ");
    
    /*count letters, words and sentences*/
    int letters = 0;
    int words = 1;
    int sentences = 0;
    
    for (int i = 0, len = strlen(input); i < len; i++)
    {
        if (tolower(input[i]) >= 'a' && tolower(input[i]) <= 'z')
        {
            letters++;
        }
        else if (input[i] == ' ')
        {
            words++;
        }
        else if (input[i] == '.' || input[i] == '!' || input[i] == '?')
        {
            sentences++;
        }
    }

    /*Coleman-Liau index*/
    float L = (float)letters / (float)words * 100;
    float S = (float)sentences / (float)words * 100;
    float index = 0.0588 * L - 0.296 * S - 15.8;
    index = round(index);

    if (index >= 16)
    {
        printf("Grade 16+\n");
    }
    else if (index < 1)
    {
        printf("Before Grade 1\n");
    }
    else
    {
        printf("Grade %i\n", (int)index);
    }
}