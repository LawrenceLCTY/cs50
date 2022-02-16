#include <stdio.h>
#include <stdlib.h>


int main(int argc, char *argv[])
{
    //usage check
    if (argc != 2)
    {
        printf("Usage: ./recover card.raw\n");
        return 1;
    }
    
    FILE *file = fopen(argv[1], "r");
    if (file == NULL)
    {
        printf("Unable to open file");
        return 1;
    }
    
    //declare variables
    unsigned char buff[512];
    int count = 0;
    FILE *img  = NULL;
    int found = 0;
    char fname[8];
    
    while (fread(buff, 512, 1, file) == 1)
    {
        //check jpeg header
        if (buff[0] == 0xff && buff[1] == 0xd8 && buff[2] == 0xff && (buff[3] & 0xf0) == 0xe0)
        {
            if (found == 1)
            {
                //found header, close current image
                fclose(img);
            }
            else
            {
                found = 1;
            }
            
            sprintf(fname, "%03i.jpg", count);
            img = fopen(fname, "w");
            count++;
        }
        
        //write byte into new file
        if (found == 1)
        {
            fwrite(&buff, 512, 1, img);
        }
    }
    
    //close files
    fclose(file);
    fclose(img);
    
    return 0;

}
