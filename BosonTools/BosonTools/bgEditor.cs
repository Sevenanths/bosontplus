using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace BosonTools
{
    public partial class bgEditor : Form
    {
        private frmMain main;

        bgEdit bgEdit = new bgEdit();
        string levelname = "";
        public bgEditor(frmMain main)
        {
            this.main = main;
            InitializeComponent();
        }

        private void pnlBgEdit_Paint(object sender, PaintEventArgs e)
        {
            

                //e.Graphics.DrawImage(Image.FromFile("Z:/Projecten/bosont+/photoshop/barrier.png"), 0, 0, 601, 338);
                //e.Graphics.DrawImage(Image.FromFile("Z:/Projecten/bosont+/photoshop/lane.png"), 0, 0, 601, 338);
                //e.Graphics.DrawImage(Image.FromFile("Z:/Projecten/bosont+/photoshop/energy.png"), 0, 0, 601, 338);
                //e.Graphics.DrawImage(Image.FromFile("Z:/Projecten/bosont+/photoshop/collapse.png"), 0, 0, 601, 338);
            
        }

        private void bgEditor_Load(object sender, EventArgs e)
        {
            

        }
        private void cbxStageSelect_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (cbxStageSelect.Text)
            {
                case "stage 1":
                    levelname = "bg_stage1.lua";
                    pnlBg.Invalidate();
                    break;
                case "stage 2":
                    levelname = "bg_stage2.lua";
                    pnlBg.Invalidate();
                    break;
                case "stage 3":
                    levelname = "bg_stage3.lua";
                    pnlBg.Invalidate();
                    break;
                case "stage 4":
                    levelname = "bg_stage4.lua";
                    pnlBg.Invalidate();
                    break;
                case "stage 5":
                    levelname = "bg_stage5.lua";
                    pnlBg.Invalidate();
                    break;
                case "stage 6":
                    levelname = "bg_stage6.lua";
                    pnlBg.Invalidate();
                    break;
            }
            bgEdit.loadBackgroundData(main.datalocation + levelname, lvwSections);
            //bgEdit.visualizeBackgrounds(main.datalocation + levelname, pnlBg);
        }

        private void lvwSections_SelectedIndexChanged(object sender, EventArgs e)
        {
            bgEdit.listviewToEditables(lvwSections, txtValue, LblColour, lblDeclColour);
            //MessageBox.Show(lvwSections.SelectedItems[0].Tag.ToString());
        }
    }
}
