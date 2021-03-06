﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace BosonTools
{
    class bgEdit
    {
        public static Bitmap ChangeColor(Bitmap scrBitmap, Color newColor)
        {
            //You can change your new color here. Red,Green,LawnGreen any..
            Color actulaColor;
            //make an empty bitmap the same size as scrBitmap
            Bitmap newBitmap = new Bitmap(scrBitmap.Width, scrBitmap.Height);
            for (int i = 0; i < scrBitmap.Width; i++)
            {
                for (int j = 0; j < scrBitmap.Height; j++)
                {
                    //get the pixel from the scrBitmap image
                    actulaColor = scrBitmap.GetPixel(i, j);
                    // > 150 because.. Images edges can be of low pixel colr. if we set all pixel color to new then there will be no smoothness left.
                    if (actulaColor.A > 150)
                        newBitmap.SetPixel(i, j, newColor);
                    else
                        newBitmap.SetPixel(i, j, actulaColor);
                }
            }
            return newBitmap;
        }
        public void visualizeBackgrounds(string luapath, Panel pnl)
        {
            string[] bglines = File.ReadAllLines(luapath);
            foreach (string bgline in bglines)
            {
                if (bgline.StartsWith("params"))
                {
                    string bgtype = bgline.Split(new char[] { '.', '=' }, StringSplitOptions.None)[1].Trim();
                    MatchCollection bracketcollection = Regex.Matches(bgline, "{(.*?)}");
                    foreach (Match matchbracket in bracketcollection)
                    {
                        if (bgtype == "bg_color")
                        {
                            int[] rgbint = matchtorgb(matchbracket);
                            pnl.BackColor = Color.FromArgb(rgbint[0], rgbint[1], rgbint[2]);
                        }
                        else if (bgtype == "master_ambient")
                        {
                            int[] rgbint = matchtorgb(matchbracket);

                        }
                    }
                }
            }
        }
        public int[] matchtorgb(Match matchbracket)
        {
            string[] rgbstring = matchbracket.Value.Replace("{", "").Replace("}", "").Split(',');
            int[] rgbint = Array.ConvertAll<string, int>(rgbstring, int.Parse);
            return rgbint;
        }
    }
}
