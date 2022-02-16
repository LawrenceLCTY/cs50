// Implements a dictionary's functionality

#include <stdbool.h>
#include <stdio.h>
#include <cs50.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 99999999; //why not lol
//hash value and hash count
unsigned int hval, count;
// Hash table
node *table[N];

// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    //open file and validate
    FILE *file = fopen(dictionary, "r");
    if (file == NULL)
    {
        return false;
    }

    char word[LENGTH + 1];

    //run until end fo file (EOF)
    while (fscanf(file, "%s", word) != EOF)
    {
        node *n = malloc(sizeof(node));

        if (n == NULL)
        {
            return false;
        }

        //move values
        strcpy(n->word, word);
        hval = hash(word);
        n->next = table[hval];
        table[hval] = n;
        count++;
    }

    //close file and return 
    fclose(file);
    return true;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    int c;
    unsigned long hnum = 5381;
    while ((c = tolower(*word++)))
    {
        //hnum * 33 + c
        hnum = ((hnum << 5) + hnum)  + c;
    }

    return hnum % N;
}

// Returns number of words in dictionary if loaded else 0 if not yet loaded
unsigned int size(void)
{
    //this should be pretty self explanatory :D
    if (count != 0)
    {
        return count;
    }

    return 0;
}

// Returns true if word is in dictionary else false
bool check(const char *word)
{
    hval = hash(word);
    node *ptr = table[hval];

    //run until end of linked list
    while (ptr != NULL)
    {
        //compare ignoring case
        if (strcasecmp(word, ptr->word) == 0)
        {
            return true;
        }
        //move to next pointer
        ptr = ptr->next;
    }

    return false;
}

// Unloads dictionary from memory, returning true if successful else false
bool unload(void)
{
    for (int i = 0; i < N; i++)
    {
        node *ptr = table[i];
        //run until end of linked list
        while (ptr != NULL)
        {
            //store temporary pointer before freeing
            node *temp = ptr;
            ptr = ptr->next;
            free(temp);
        }

        //end of list
        if (i == N - 1 && ptr == NULL)
        {
            return true;
        }

    }
    return false;
}
