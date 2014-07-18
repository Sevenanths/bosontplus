using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace BosonTools
{
    public partial class frmLevelEditor : Form
    {
        public string datalocation;
        public string cachefile = Application.StartupPath + "/cachefile.txt";
        public frmLevelEditor()
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

        private void txtGamePath_TextChanged(object sender, EventArgs e)
        {

        }
        public void assignDataLocation()
        {
            if (!(Properties.Settings.Default.gamespath == ""))
            {
                datalocation = Properties.Settings.Default.gamespath + "/data";
            }
        }
        private void frmLevelEditor_Load(object sender, EventArgs e)
        {
            txtGamePath.Text = Properties.Settings.Default.gamespath;
            assignDataLocation();

            List<string> levelPlatforms = new List<string>();
        }
        private void unlockGUI()
        {

        }

        private void cbxStages_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (cbxStages.Text)
            {
                case "stage 1": return;

            }
        }

        private void btnDebugParse_Click(object sender, EventArgs e)
        {
            string patterncontents = File.ReadAllText(datalocation + "/patterns_stage1.lua");
            string[] patterns = patterncontents.Split(new char[] { '{', '}' });
            File.WriteAllText(cachefile, "");
            foreach (string pattern in patterns)
            {
                if (!(pattern.Contains("--")))
                {
                    if (!(pattern[0] == ','))
                    {
                        if (!(String.IsNullOrWhiteSpace(pattern)))
                        {
                            if (!(pattern.Contains("return")))
                            {
                                using (StringReader reader = new StringReader(pattern))
                                {
                                    using (System.IO.StreamWriter cfile = File.AppendText(@cachefile))
                                    {
                                        string line = string.Empty;
                                        do
                                        {
                                            line = reader.ReadLine();
                                            if (line != null)
                                            {
                                                if (line.Contains("name"))
                                                {
                                                    MatchCollection matches = Regex.Matches(line, "\"(.*?)\"");
                                                    foreach (Match match in matches)
                                                    {
                                                        cfile.WriteLine(match.ToString().Replace("\"", ""));
                                                    }
                                                }
                                                else if (line.Contains("]]"))
                                                {

                                                }
                                                else
                                                {
                                                    cfile.WriteLine(line);
                                                }
                                            }
                                        } while (line != null);

                                        cfile.WriteLine("*");
                                    }
                                }
                            }
                        }
                    }
                }
            }
            loadCacheFileIntoListView(lvwSections);
        }
        private void loadCacheFileIntoListView(ListView lvw)
        {

        }
        private void cbxSections_SelectedIndexChanged(object sender, EventArgs e)
        {
            //string pattern = File.ReadAllText(cachefile).Split('*')[lvwSections.SelectedIndices[0]];
            //using (StringReader reader = new StringReader(pattern))
            //{
            //    using (System.IO.StreamWriter cfile = File.AppendText(@cachefile))
            //    {
            //        string line = string.Empty;
            //        do
            //        {
            //            line = reader.ReadLine();
            //            if (line != null)
            //            {

            //            }
            //        } while (line != null);

            //        cfile.WriteLine("*");
            //    }
            //}
        }

        private void removeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            lvwSections.SelectedItems[0].Remove();
        }

        private void lvwSections_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lvwSections.SelectedItems.Count > 0)
            {
                dgvLevelEdit.Rows.Clear();
                //MessageBox.Show(lvwSections.SelectedItems[0].Tag.ToString());
                if (!(lvwSections.SelectedItems[0].Tag == null))
                {
                    string[] patternpieces = lvwSections.SelectedItems[0].Tag.ToString().Split('\n');
                    foreach (string patternpiece in patternpieces)
                    {
                        //Debug.WriteLine("\n");
                        string[] patternpiecesplatforms = patternpiece.Split('|');
                        DataGridViewRow row = new DataGridViewRow();
                        int counter = 0;
                        foreach (string patternpieceplatform in patternpiecesplatforms)
                        {
                            if (!(counter == 0))
                            {
                                DataGridViewCell cell = new DataGridViewTextBoxCell();
                                if (patternpieceplatform.StartsWith("P"))
                                {
                                    cell.Style.BackColor = Color.DarkGray;
                                    cell.Style.ForeColor = Color.White;
                                }
                                else if (patternpieceplatform.StartsWith("F"))
                                {
                                    cell.Style.BackColor = Color.Orange;
                                    cell.Style.ForeColor = Color.Black;
                                }
                                else if (patternpieceplatform.StartsWith("C"))
                                {
                                    cell.Style.BackColor = Color.DarkRed;
                                    cell.Style.ForeColor = Color.White;
                                }
                                else if (patternpieceplatform.StartsWith("E"))
                                {
                                    cell.Style.BackColor = Color.LightBlue;
                                    cell.Style.ForeColor = Color.Black;
                                }
                                else if (patternpieceplatform.StartsWith("B"))
                                {
                                    cell.Style.BackColor = Color.Gray;
                                    cell.Style.ForeColor = Color.White;
                                }
                                cell.Value = patternpieceplatform;
                                row.Cells.Add(cell);
                            }
                            counter++;
                        }
                        dgvLevelEdit.Rows.Add(row);
                        //dgvLevelEdit.Rows.Add(patternpiecesplatforms[1], patternpiecesplatforms[2], patternpiecesplatforms[3], patternpiecesplatforms[4], patternpiecesplatforms[5], patternpiecesplatforms[6], patternpiecesplatforms[7], patternpiecesplatforms[8], patternpiecesplatforms[9], patternpiecesplatforms[10], patternpiecesplatforms[11]);
                    }
                }
            }
        }
        private void btnDebugParseNouveau_Click(object sender, EventArgs e)
        {
            string[] patterncontents = File.ReadAllLines(datalocation + "/patterns_stage1.lua");
            string patterncontentplain = "";
            foreach (string patterncontent in patterncontents.Skip(2))
            {
                patterncontentplain += "\n" + patterncontent;
            }
            lvwSections.Items.Clear();
            string[] patterns = patterncontentplain.Split(new char[] { '{', '}' });
            File.WriteAllText(cachefile, patterncontentplain);
            foreach (string pattern in patterns)
            {
                string[] patternpieces = pattern.Split('\n');
                if (!(patternpieces[0] == ""))
                {
                    ListViewItem item = new ListViewItem();
                    foreach (string patternpiece in patternpieces)
                    {
                        if (patternpiece.StartsWith("name = \""))
                        {
                            item.Text = Regex.Matches(patternpiece, "\"(.*?)\"")[0].ToString().Replace("\"", "");
                        }
                        else if (patternpiece.StartsWith("|"))
                        {
                            if (item.Tag == null)
                            {
                                item.Tag = patternpiece;
                            }
                            else
                            {
                                item.Tag += "\n" + patternpiece;
                            }
                        }
                    }
                    if (!(item.Text == ""))
                    {
                        lvwSections.Items.Add(item);
                    }
                }
            }
        }

        private void dgvLevelEdit_CellMouseClick(object sender, DataGridViewCellMouseEventArgs e)
        {
            //if (e.Button == MouseButtons.Right)
            //{
            //    if (e.ColumnIndex == -1 == false && e.RowIndex == -1 == false)
            //    {
            //        dgvLevelEdit.ClearSelection();
            //        dgvLevelEdit.CurrentCell = dgvLevelEdit[e.ColumnIndex, e.RowIndex];

            //        cmsPlatformTypes.Show(Cursor.Position);
            //    }
            //}
        }
        private void toolStripMenuItemAir_Click(object sender, EventArgs e)
        {
            changeVellCalue("");
        }
        private void normalPToolStripMenuItem_Click(object sender, EventArgs e)
        {
            changeVellCalue("P");
        }

        private void fastFToolStripMenuItem_Click(object sender, EventArgs e)
        {
            changeVellCalue("F");
        }

        private void collapsingCToolStripMenuItem_Click(object sender, EventArgs e)
        {
            changeVellCalue("C");
        }

        private void energyEToolStripMenuItem_Click(object sender, EventArgs e)
        {
            changeVellCalue("E");
        }

        private void barrierBToolStripMenuItem_Click(object sender, EventArgs e)
        {
            changeVellCalue("B");
        }

        private void toolStripMenuItem1_Click(object sender, EventArgs e)
        {
            changeVellCalue("1");
        }

        private void toolStripMenuItem2_Click(object sender, EventArgs e)
        {
            changeVellCalue("2");
        }

        private void toolStripMenuItem3_Click(object sender, EventArgs e)
        {
            changeVellCalue("3");
        }

        private void toolStripMenuItem4_Click(object sender, EventArgs e)
        {
            changeVellCalue("4");
        }

        private void toolStripMenuItem5_Click(object sender, EventArgs e)
        {
            changeVellCalue("5");
        }

        private void toolStripMenuItem6_Click(object sender, EventArgs e)
        {
            changeVellCalue("6");
        }

        private void toolStripMenuItem7_Click(object sender, EventArgs e)
        {
            changeVellCalue("7");
        }

        private void toolStripMenuItem8_Click(object sender, EventArgs e)
        {
            changeVellCalue("8");
        }

        private void toolStripMenuItem9_Click(object sender, EventArgs e)
        {
            changeVellCalue("9");
        }

        private void changeVellCalue(string type)
        {
            foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
            {
                if (cell.Value == null)
                {
                    cell.Value = "  ";
                }
            }

            switch (type)
            {
                // PLATFORM TYPES
                case "":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        cell.Value = "  ";
                        cell.Style.BackColor = Color.White;
                        cell.Style.ForeColor = Color.Black;
                    }
                    break;
                case "P":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[0] = 'P';
                        if (arr[1] == ' ')
                        {
                            arr[1] = '1';
                        }
                        cell.Value = new string(arr);
                        cell.Style.BackColor = Color.DarkGray;
                        cell.Style.ForeColor = Color.White;
                    }
                    break;
                case "F":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[0] = 'F';
                        if (arr[1] == ' ')
                        {
                            arr[1] = '1';
                        }
                        cell.Value = new string(arr);
                        cell.Style.BackColor = Color.Orange;
                        cell.Style.ForeColor = Color.Black;
                    }
                    break;
                case "C":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[0] = 'C';
                        if (arr[1] == ' ')
                        {
                            arr[1] = '1';
                        }
                        cell.Value = new string(arr);
                        cell.Style.BackColor = Color.DarkRed;
                        cell.Style.ForeColor = Color.White;
                    }
                    break;
                case "E":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[0] = 'E';
                        if (arr[1] == ' ')
                        {
                            arr[1] = '1';
                        }
                        cell.Value = new string(arr);
                        cell.Style.BackColor = Color.LightBlue;
                        cell.Style.ForeColor = Color.Black;
                    }
                    break;
                case "B":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[0] = 'B';
                        if (arr[1] == ' ')
                        {
                            arr[1] = '1';
                        }
                        cell.Value = new string(arr);
                        cell.Style.BackColor = Color.Gray;
                        cell.Style.ForeColor = Color.White;
                    }
                    break;

                // PLATFORM ALTITUDE
                case "1":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[1] = '1';
                        if (arr[0] == ' ')
                        {
                            arr[0] = 'P';
                            cell.Style.BackColor = Color.Gray;
                            cell.Style.ForeColor = Color.White;
                        }
                        cell.Value = new string(arr);
                    }
                    break;
                case "2":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[1] = '2';
                        if (arr[0] == ' ')
                        {
                            arr[0] = 'P';
                            cell.Style.BackColor = Color.Gray;
                            cell.Style.ForeColor = Color.White;
                        }
                        cell.Value = new string(arr);
                    }
                    break;
                case "3":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[1] = '3';
                        if (arr[0] == ' ')
                        {
                            arr[0] = 'P';
                            cell.Style.BackColor = Color.Gray;
                            cell.Style.ForeColor = Color.White;
                        }
                        cell.Value = new string(arr);
                    }
                    break;
                case "4":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[1] = '4';
                        if (arr[0] == ' ')
                        {
                            arr[0] = 'P';
                            cell.Style.BackColor = Color.Gray;
                            cell.Style.ForeColor = Color.White;
                        }
                        cell.Value = new string(arr);
                    }
                    break;
                case "5":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[1] = '5';
                        if (arr[0] == ' ')
                        {
                            arr[0] = 'P';
                            cell.Style.BackColor = Color.Gray;
                            cell.Style.ForeColor = Color.White;
                        }
                        cell.Value = new string(arr);
                    }
                    break;
                case "6":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[1] = '6';
                        if (arr[0] == ' ')
                        {
                            arr[0] = 'P';
                            cell.Style.BackColor = Color.Gray;
                            cell.Style.ForeColor = Color.White;
                        }
                        cell.Value = new string(arr);
                    }
                    break;
                case "7":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[1] = '7';
                        if (arr[0] == ' ')
                        {
                            arr[0] = 'P';
                            cell.Style.BackColor = Color.Gray;
                            cell.Style.ForeColor = Color.White;
                        }
                        cell.Value = new string(arr);
                    }
                    break;
                case "8":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[1] = '8';
                        if (arr[0] == ' ')
                        {
                            arr[0] = 'P';
                            cell.Style.BackColor = Color.Gray;
                            cell.Style.ForeColor = Color.White;
                        }
                        cell.Value = new string(arr);
                    }
                    break;
                case "9":
                    foreach (DataGridViewCell cell in dgvLevelEdit.SelectedCells)
                    {
                        char[] arr = cell.Value.ToString().ToCharArray();
                        arr[1] = '9';
                        if (arr[0] == ' ')
                        {
                            arr[0] = 'P';
                            cell.Style.BackColor = Color.Gray;
                            cell.Style.ForeColor = Color.White;
                        }
                        cell.Value = new string(arr);
                    }
                    break;
            }
        }

        private void txtSectionAdd_TextChanged(object sender, EventArgs e)
        {

        }

        private void btnSectionAdd_Click(object sender, EventArgs e)
        {
            if (!(txtSectionAdd.Text == ""))
            {
                lvwSections.Items.Add(txtSectionAdd.Text);
            }

        }

        private void btnInsertRow_Click(object sender, EventArgs e)
        {
            //dgvLevelEdit.Rows.Insert(dgvLevelEdit.SelectedCells[dgvLevelEdit.SelectedCells.Count].RowIndex);
        }

        private void btnRemoveRow_Click(object sender, EventArgs e)
        {
            if (dgvLevelEdit.SelectedRows.Count > 0)
            {
                foreach (DataGridViewRow row in dgvLevelEdit.SelectedRows)
                {
                    if (!(row.IsNewRow))
                    {
                        dgvLevelEdit.Rows.Remove(row);
                    }
                }
            }
        }

        private void btnSaveChanges_Click(object sender, EventArgs e)
        {
            lvwSections.SelectedItems[0].Tag = "";
            foreach (DataGridViewRow row in dgvLevelEdit.Rows)
            {
                if (!(row.IsNewRow))
                {
                    foreach (DataGridViewCell cell in row.Cells)
                    {
                        if (cell.Value == null)
                        {
                            cell.Value = "  ";
                        }
                    }
                    //if (lvwSections.SelectedItems[0].Tag == ""){
                    //    lvwSections.SelectedItems[0].Tag = "|" + row.Cells[0] + "|" + row.Cells[1] + "|" + row.Cells[2] + "|" + row.Cells[3] + "|" + row.Cells[4] + "|" + row.Cells[5] + "|" + row.Cells[6] + "|" + row.Cells[7] + "|" + row.Cells[7] + "|" + row.Cells[8] + "|" + row.Cells[9] + "|" + row.Cells[10] + "\n"; 
                    //}
                    //else
                    //{
                    lvwSections.SelectedItems[0].Tag += "|" + row.Cells[0].Value + "|" + row.Cells[1].Value + "|" + row.Cells[2].Value + "|" + row.Cells[3].Value + "|" + row.Cells[4].Value + "|" + row.Cells[5].Value + "|" + row.Cells[6].Value + "|" + row.Cells[7].Value + "|" + row.Cells[8].Value + "|" + row.Cells[9].Value + "|" + row.Cells[10].Value + "\n";
                    //}
                }
            }
            MessageBox.Show(lvwSections.SelectedItems[0].Tag.ToString());
        }
    }
}