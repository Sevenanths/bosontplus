using System;
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
            //string luapath = main.datalocation + levelname;

            if (File.Exists(luapath))
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
                                //e.Graphics.DrawImage(bgEdit.ChangeColor(Properties.Resources.lane, Color.FromArgb(rgbint[0], rgbint[1], rgbint[2])), 0, 0, 601, 338);
                            }
                        }
                    }
                }
            }
        }

        public void loadBackgroundData(string luapath, ListView lvw)
        {
            if (File.Exists(luapath))
            {
                lvw.Items.Clear();

                string[] bglines = File.ReadAllLines(luapath);
                foreach (string bgline in bglines)
                {
                    ListViewItem item = new ListViewItem();
                    if (bgline.StartsWith("params"))
                    {
                        string bgtype = bgline.Split(new char[] { '.', '=' }, StringSplitOptions.None)[1].Trim();
                        item.Text = bgtype;
                        MatchCollection bracketcollection = Regex.Matches(bgline, "{(.*?)}");
                        if (bracketcollection.Count > 0)
                        {
                            foreach (Match matchbracket in bracketcollection)
                            {
                                item.Tag = matchbracket.Value.Replace("{", "").Replace("}", "");
                            }
                        }
                        else
                        {
                            int equalsindex = bgline.IndexOf('=');
                            //MessageBox.Show(equalsindex.ToString(), bgline.Length.ToString());
                            string normalvalue = bgline.Substring(equalsindex + 2);
                            item.Tag = normalvalue;
                        }
                        lvw.Items.Add(item);
                    }
                }
            }
        }
        public void loadBackgroundDataNouveau(string luapath, ListView lvw)
        {
            if (File.Exists(luapath))
            {
                string[] bglines = File.ReadAllLines(luapath);
                foreach (string bgline in bglines)
                {
                    if (bgline.StartsWith("params"))
                    {
                        string bgtype = bgline.Split(new char[] { '.', '=' }, StringSplitOptions.None)[1].Trim();
                        foreach (ListViewItem item in lvw.Items)
                        {
                            if (item.Text == bgtype)
                            {
                                MatchCollection bracketcollection = Regex.Matches(bgline, "{(.*?)}");
                                if (bracketcollection.Count > 0)
                                {
                                    foreach (Match matchbracket in bracketcollection)
                                    {
                                        item.Tag = "color;" + matchbracket.Value.Replace("{", "").Replace("}", "");
                                    }
                                }
                                else
                                {
                                    int equalsindex = bgline.IndexOf('=');
                                    //MessageBox.Show(equalsindex.ToString(), bgline.Length.ToString());
                                    string normalvalue = bgline.Substring(equalsindex + 2).Trim();
                                    item.Tag = "value; " + normalvalue;
                                }
                            }

                            if (item.Tag == null)
                            {
                                item.Tag = "";
                            }
                        }
                    }
                }
            }
        }
        public void listviewToEditables(ListView lvw, TextBox txt, LinkLabel llbl, Label lbl)
        {
            txt.Visible = false;
            txt.Visible = false;
            lbl.Visible = false;
            llbl.Visible = false;

            if (lvw.SelectedItems.Count > 0)
            {
                ListViewItem item = lvw.SelectedItems[0];

                if (!(item.Text == "particles_color"))
                {
                    if (item.Tag.ToString().Contains(","))
                    {
                        llbl.Visible = true;
                        llbl.Text = item.Tag.ToString();

                        int[] color = stringtorgb(item.Tag.ToString());
                        llbl.LinkColor = Color.FromArgb(color[0], color[1], color[2]);
                    }
                    else
                    {
                        txt.Visible = true;
                        txt.Text = item.Tag.ToString().Replace("\"", "");
                    }
                }
            }
        }
        public void listviewtoEditablesNouveau(ListView lvw, TextBox txt, LinkLabel llbl, Label lbl)
        {
            txt.Visible = false;
            txt.Visible = false;
            lbl.Visible = false;
            llbl.Visible = false;

            if (lvw.SelectedItems.Count > 0)
            {
                ListViewItem item = lvw.SelectedItems[0];

                if (!(item.Text == "particles_color") && !(item.Text == "particles_color_alt"))
                {
                    if (item.Tag.ToString().Split(';')[0] == "color")
                    {
                        if (!(item.Tag.ToString().Split(';')[1] == ""))
                        {
                            llbl.Visible = true;
                            llbl.Text = item.Tag.ToString().Split(';')[1];

                            int[] color = stringtorgb(item.Tag.ToString().Split(';')[1]);
                            llbl.LinkColor = Color.FromArgb(color[0], color[1], color[2]);
                        }
                        else
                        {
                            llbl.Visible = true;
                            llbl.Text = "color not set";
                            llbl.LinkColor = Color.Black;
                        }
                    }
                    else if (item.Tag.ToString().Split(';')[0] == "value")
                    {
                        txt.Visible = true;
                        txt.Text = item.Tag.ToString().Split(';')[1].Trim().Replace("\"", "");
                    }
                }
            }
        }
        public int[] stringtorgb(string value)
        {
            string[] rgbstring = value.Split(',');
            int[] rgbint = Array.ConvertAll<string, int>(rgbstring, int.Parse);
            return rgbint;
        }
        public int[] matchtorgb(Match matchbracket)
        {
            string[] rgbstring = matchbracket.Value.Replace("{", "").Replace("}", "").Split(',');
            int[] rgbint = Array.ConvertAll<string, int>(rgbstring, int.Parse);
            return rgbint;
        }
        public void colorDialogEvent(LinkLabel llbl, ListView lvw)
        {
            ColorDialog colours = new ColorDialog();
            colours.AllowFullOpen = true;
            colours.AnyColor = true;
            if (colours.ShowDialog() == DialogResult.OK)
            {
                llbl.LinkColor = colours.Color;
                string colorstring = colours.Color.R.ToString() + ", " + colours.Color.G.ToString() + ", " + colours.Color.B.ToString();
                llbl.Text = colorstring;
                lvw.SelectedItems[0].Tag = "color;" + colorstring;
            }
        }
        public void textboxEvent(TextBox txt, ListView lvw)
        {
            lvw.SelectedItems[0].Tag = "value;\"" + txt.Text + "\"";
        }
        public void buildLua(string luapath, ListView lvw)
        {
            File.WriteAllText(luapath, "");
            using (StreamWriter streamWriter = File.AppendText(luapath))
            {
                streamWriter.WriteLine("local level = ...");
                streamWriter.WriteLine("local params = {}");
                foreach (ListViewItem item in lvw.Items)
                {
                    if (!(item.Text == "particles_color_alt" && item.Text == "particles_color"))
                    {
                        if (item.Tag.ToString().Split(';')[0] == "color")
                        {
                            if (!(item.Tag.ToString().Split(';')[1] == ""))
                            {
                                streamWriter.WriteLine("params." + item.Text + " = {" + item.Tag.ToString().Split(';')[1] + "}");
                            }
                        }
                        else if (item.Tag.ToString().Split(';')[0] == "value")
                        {
                            if (!(item.Tag.ToString().Split(';')[1] == ""))
                            {
                                streamWriter.WriteLine("params." + item.Text + " = " + item.Tag.ToString().Split(';')[1]);
                            }
                        }
                    }
                }
                streamWriter.WriteLine("import(\"bg_common\", level, params)");
            }
        }
    }
}
