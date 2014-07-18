using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace BosonTools
{
    public partial class frmMain : Form
    {
        public string datalocation;
        public frmMain()
        {
            InitializeComponent();
        }

        private void btnBrowseGamePath_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog browseForGamePath = new FolderBrowserDialog();
            browseForGamePath.Description = "Please select the location where your 'bosonx.exe' file, alongside with the 'data' folder is located.";
            if (browseForGamePath.ShowDialog() == DialogResult.OK)
            {
                if (Directory.Exists(browseForGamePath.SelectedPath + "/data"))
                {
                    txtGamePath.Text = browseForGamePath.SelectedPath;
                    Properties.Settings.Default.gamespath = txtGamePath.Text;
                    Properties.Settings.Default.Save();
                    assignDataLocation();
                }
            }
        }
        public void assignDataLocation()
        {
            if (!(Properties.Settings.Default.gamespath == ""))
            {
                datalocation = Properties.Settings.Default.gamespath + "/data/";
                pnlButtons.Enabled = true;
            }
        }

        private void frmMain_Load(object sender, EventArgs e)
        {
            txtGamePath.Text = Properties.Settings.Default.gamespath;
            assignDataLocation();
        }

        private void btnPatternEdit_Click(object sender, EventArgs e)
        {
            frmLevelEditorNeue newLevelEditor = new frmLevelEditorNeue(this);
            newLevelEditor.Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            bgEditor bgedit = new bgEditor(this);
            bgedit.Show();
        }
    }
}
