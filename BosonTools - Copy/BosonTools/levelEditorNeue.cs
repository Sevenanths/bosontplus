using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace BosonTools
{
    public partial class frmLevelEditorNeue : Form
    {
        private frmMain main;
        patternEdit patternEdit = new patternEdit();
        private string levelname = "";
        public frmLevelEditorNeue(frmMain main)
        {
            InitializeComponent();
            this.main = main;
        }

        private void frmLevelEditorNeue_Load(object sender, EventArgs e)
        {

        }

        private void cbxStageSelect_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (cbxStageSelect.Text)
            {
                case "stage 1":
                levelname = "patterns_stage1.lua";
                break;
                case "stage 2":
                levelname = "patterns_stage2.lua";
                break;
                case "stage 3":
                levelname = "patterns_stage3.lua";
                break;
                case "stage 4":
                levelname = "patterns_stage4.lua";
                break;
                case "stage 5":
                levelname = "patterns_stage5.lua";
                break;
                case "stage 6":
                levelname = "patterns_stage6.lua";
                break; 
            }

            patternEdit.clearDataStructures(lvwSections, dgvLevelEdit, cbxNoEnergy, txtStages);
            patternEdit.parsePatternsNouveau(main.datalocation + levelname, lvwSections);
    }

        private void lvwSections_SelectedIndexChanged(object sender, EventArgs e)
        {
            patternEdit.visualiseSection(lvwSections, dgvLevelEdit, cbxNoEnergy, txtStages);
        }

        private void removeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            lvwSections.SelectedItems[0].Remove();
        }

        private void toolStripMenuItemAir_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("", dgvLevelEdit);
        }

        private void normalPToolStripMenuItem_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("P", dgvLevelEdit);
        }

        private void fastFToolStripMenuItem_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("F", dgvLevelEdit);
        }

        private void collapsingCToolStripMenuItem_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("C", dgvLevelEdit);
        }

        private void energyEToolStripMenuItem_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("E", dgvLevelEdit);
        }

        private void barrierBToolStripMenuItem_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("B", dgvLevelEdit);
        }

        private void toolStripMenuItem1_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("1", dgvLevelEdit);
        }

        private void toolStripMenuItem2_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("2", dgvLevelEdit);
        }

        private void toolStripMenuItem3_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("3", dgvLevelEdit);
        }

        private void toolStripMenuItem4_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("4", dgvLevelEdit);
        }

        private void toolStripMenuItem5_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("5", dgvLevelEdit);
        }

        private void toolStripMenuItem6_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("6", dgvLevelEdit);
        }

        private void toolStripMenuItem7_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("7", dgvLevelEdit);
        }

        private void toolStripMenuItem8_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("8", dgvLevelEdit);
        }

        private void toolStripMenuItem9_Click(object sender, EventArgs e)
        {
            patternEdit.changeCellValue("9", dgvLevelEdit);
        }

        private void btnSaveChanges_Click(object sender, EventArgs e)
        {
            patternEdit.saveChanges(lvwSections, dgvLevelEdit, cbxNoEnergy, txtStages);
            patternEdit.buildLua(main.datalocation + levelname, lvwSections);
        }
  }
}