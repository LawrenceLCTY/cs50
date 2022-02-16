# include "helpers.h"
# include <math.h>


// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    float val;
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            val = round((image[i][j].rgbtRed + image[i][j].rgbtGreen + image[i][j].rgbtBlue) / 3.0);
            image[i][j].rgbtRed = image[i][j].rgbtGreen = image[i][j].rgbtBlue = (int)val;
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE temp;
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width / 2; j++)
        {
            temp = image[i][j];
            image[i][j] = image[i][width - 1 - j];
            image[i][width - 1 - j] = temp;
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    /*get neighbours, remove if > width or > height or < 0
    value = (tot all neighbours and self) / 9*/
    RGBTRIPLE temp[height][width];
    int tempR, tempG, tempB, count, i, j, x, y;
    float totR, totG, totB;
    for (i = 0; i < height; i++)
    {
        for (j = 0; j < width; j++)
        {
            totR = totG = totB = count = 0;
            for (x = -1; x <= 1; x++)
            {
                if (i + x < 0 || i + x > height - 1)
                {
                    continue;
                }
                for (y = -1; y <= 1; y++)
                {
                    if (j + y < 0 || j + y > height - 1)
                    {
                        continue;
                    }

                    totR += image[i + x][j + y].rgbtRed;
                    totG += image[i + x][j + y].rgbtGreen;
                    totB += image[i + x][j + y].rgbtBlue;
                    count++;
                }
            }

            temp[i][j].rgbtRed = round(totR / count);
            temp[i][j].rgbtGreen = round(totG / count);
            temp[i][j].rgbtBlue = round(totB / count);
        }
    }

    for (i = 0; i < height; i++)
    {
        for (j = 0; j < width; j++)
        {
            image[i][j].rgbtRed = temp[i][j].rgbtRed;
            image[i][j].rgbtGreen = temp[i][j].rgbtGreen;
            image[i][j].rgbtBlue = temp[i][j].rgbtBlue;
        }
    }

    return;
}


// Detect edges
void edges(int height, int width, RGBTRIPLE image[height][width])
{
    float R, G, B, r, g, b;
    int rgb[3];
    RGBTRIPLE temp[height][width];
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            temp[i][j] = image[i][j];
        }
    }
    // Initialise Sobel arrays
    int Gx[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    int Gy[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
    
    for (int i = 0; i < height; i++)
    {
        // Loop through columns
        for (int j = 0; j < width; j++)
        {
            // Initialise ints
            R = G = B = r = g = b = 0;
            // For each pixel, loop vertical and horizontal
            for (int x = -1; x < 2; x++)
            {
                for (int y = -1; y < 2; y++)
                {
                    if ((i + x >= 0 && i + x < height) && (j + y >= 0 && j + y < width))
                    {
                        R += temp[i + x][j + y].rgbtRed * Gx[x + 1][y + 1];
                        G += temp[i + x][j + y].rgbtGreen * Gx[x + 1][y + 1];
                        B += temp[i + x][j + y].rgbtBlue * Gx[x + 1][y + 1];
                        r += temp[i + x][j + y].rgbtRed * Gy[x + 1][y + 1];
                        g += temp[i + x][j + y].rgbtGreen * Gy[x + 1][y + 1];
                        b += temp[i + x][j + y].rgbtBlue * Gy[x + 1][y + 1];
                    }
                }
            }
            
            //calculate final value
            rgb[0] = round(sqrt(R * R + r * r));
            rgb[1] = round(sqrt(G * G + g * g));
            rgb[2] = round(sqrt(B * B + b * b));

            //validate
            for (int x = 0; x < 3; x++)
            {
                if (rgb[x] > 255)
                {
                    rgb[x] = 255;
                }
            }

            //store back into image
            image[i][j].rgbtRed = rgb[0];
            image[i][j].rgbtGreen = rgb[1];
            image[i][j].rgbtBlue = rgb[2];
        }
    }
    return;
}
 


//reflect images vertically
void reflect_vertical(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE temp;
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width / 2; j++)
        {
            temp = image[i][j];
            image[i][j] = image[height - 1 - i][j];
            image[height - 1 - i][j] = temp;
        }
    }
    return;
}


//sepia filter
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    float s[3];

    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            s[0] = round(.393 * image[i][j].rgbtRed + .769 * image[i][j].rgbtGreen + .189 * image[i][j].rgbtBlue);
            s[1] = round(.349 * image[i][j].rgbtRed + .686 * image[i][j].rgbtGreen + .168 * image[i][j].rgbtBlue);
            s[2] = round(.272 * image[i][j].rgbtRed + .534 * image[i][j].rgbtGreen + .131 * image[i][j].rgbtBlue);

            for (int x = 0; x < 3; x++)
            {
                if (s[x] > 255)
                {
                    s[x] = 255;
                }
            }

            image[i][j].rgbtRed = (int) s[0];
            image[i][j].rgbtGreen = (int) s[1];
            image[i][j].rgbtBlue = (int) s[2];
        }
    }

    return;
}
