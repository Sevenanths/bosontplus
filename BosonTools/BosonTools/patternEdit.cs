// this code would have been more easy to look at if Visual Studio hadn't fucked up and erased this entire class. Massive thanks to dotpeek for restoring
// my source code!

using System;
using System.Collections;
using System.Drawing;
using System.IO;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace BosonTools
{
    internal class patternEdit
    {
        public void parsePatterns(string luapath, ListView lvw)
        {
            lvw.Items.Clear();
            string[] strArray = File.ReadAllLines(luapath);
            string contents = "";
            foreach (string str in strArray)
            {
                if (!str.Contains("stages ="))
                    contents = contents + str + "\n";
            }
            File.WriteAllText("//Miiserver/nas/Projecten/bosont+/test.txt", contents);
            string str1 = contents;
            char[] chArray1 = new char[2]
      {
        '{',
        '}'
      };
            foreach (string str2 in str1.Split(chArray1))
            {
                ListViewItem listViewItem1 = new ListViewItem();
                string str3 = str2;
                char[] chArray2 = new char[1]
        {
          '\n'
        };
                foreach (string input in str3.Split(chArray2))
                {
                    if (input.StartsWith("name = \""))
                        listViewItem1.Text = Regex.Matches(input, "\"(.*?)\"")[0].ToString().Replace("\"", "");
                    else if (input.StartsWith("|"))
                    {
                        ListViewItem listViewItem2 = listViewItem1;
                        string str4 = (string)listViewItem2.Tag + (object)input + "\n";
                        listViewItem2.Tag = (object)str4;
                    }
                }
                if (!(listViewItem1.Text == ""))
                    lvw.Items.Add(listViewItem1);
            }
        }

        public void parsePatternsNouveau(string luapath, ListView lvw)
        {
            string[] strArray = File.ReadAllLines(luapath);
            bool flag1 = false;
            bool flag2 = false;
            ListViewItem listViewItem1 = (ListViewItem)null;
            foreach (string input in strArray)
            {
                string str1 = input.Trim();
                if (str1.StartsWith("--"))
                    flag1 = true;
                if (!flag1)
                {
                    if (!flag2)
                    {
                        if (input.StartsWith("{name ="))
                        {
                            listViewItem1 = new ListViewItem();
                            string str2 = Regex.Matches(input, "\"(.*?)\"")[0].ToString().Replace("\"", "");
                            MatchCollection matchCollection1 = Regex.Matches(input, "noenergy = (.*?),");
                            MatchCollection matchCollection2 = Regex.Matches(input, "stages = (.*?)}");
                            string str3 = "false";
                            string str4 = "";
                            foreach (Capture capture in matchCollection1)
                            {
                                if (capture.Value.Contains("true"))
                                    str3 = "true";
                            }
                            foreach (Match match in matchCollection2)
                            {
                                if (!(match.Value == ""))
                                    str4 = Regex.Matches(match.Value, "{(.*?)}")[0].ToString().Replace("{", "").Replace("}", "");
                            }
                            listViewItem1.Name = str2;
                            listViewItem1.Text = str2;
                            listViewItem1.Tag = (object)(str3 + ";" + str4 + "\n");
                            flag2 = true;
                        }
                    }
                    else if (input.StartsWith("|"))
                    {
                        ListViewItem listViewItem2 = listViewItem1;
                        string str2 = (string)listViewItem2.Tag + (object)input + "\n";
                        listViewItem2.Tag = (object)str2;
                    }
                    else if (input.StartsWith("]]},"))
                    {
                        lvw.Items.Add(listViewItem1);
                        flag2 = false;
                    }
                }
                else if (str1.StartsWith("]=]"))
                    flag1 = false;
            }
        }

        public void clearDataStructures(ListView lvw, DataGridView dgv, ComboBox cbx, TextBox txt)
        {
            lvw.Items.Clear();
            dgv.Rows.Clear();
            cbx.Text = "";
            txt.Text = "";
        }

        public void visualiseSection(ListView lvw, DataGridView dgv, ComboBox cbx, TextBox txt)
        {
            if (lvw.SelectedItems.Count <= 0)
                return;
            dgv.Rows.Clear();
            if (lvw.SelectedItems[0].Tag != null)
            {
                string[] strArray1 = lvw.SelectedItems[0].Tag.ToString().Split(new char[1]
        {
          '\n'
        });
                int num1 = 0;
                foreach (string str1 in strArray1)
                {
                    if (num1 == 0)
                    {
                        string[] strArray2 = str1.Split(new char[1]
            {
              ';'
            });
                        cbx.Text = strArray2[0];
                        txt.Text = strArray2[1];
                    }
                    else
                    {
                        DataGridViewRow dataGridViewRow = new DataGridViewRow();
                        int num2 = 0;
                        string str2 = str1;
                        char[] chArray = new char[1]
            {
              '|'
            };
                        foreach (string str3 in str2.Split(chArray))
                        {
                            if (num2 != 0)
                            {
                                DataGridViewCell dataGridViewCell = (DataGridViewCell)new DataGridViewTextBoxCell();
                                if (!(str3 == ""))
                                {
                                    switch (str3[0])
                                    {
                                        case ' ':
                                            dataGridViewCell.Style = this.cellstyle("");
                                            break;
                                        case 'B':
                                            dataGridViewCell.Style = this.cellstyle("B");
                                            break;
                                        case 'C':
                                            dataGridViewCell.Style = this.cellstyle("C");
                                            break;
                                        case 'E':
                                            dataGridViewCell.Style = this.cellstyle("E");
                                            break;
                                        case 'F':
                                            dataGridViewCell.Style = this.cellstyle("F");
                                            break;
                                        case 'P':
                                            dataGridViewCell.Style = this.cellstyle("P");
                                            break;
                                    }
                                }
                                dataGridViewCell.Value = (object)str3;
                                dataGridViewRow.Cells.Add(dataGridViewCell);
                            }
                            ++num2;
                        }
                        dgv.Rows.Add(dataGridViewRow);
                    }
                    ++num1;
                }
            }
        }

        public void changeCellValue(string type, DataGridView dgv)
        {
            foreach (DataGridViewCell dataGridViewCell in (BaseCollection)dgv.SelectedCells)
            {
                if (dataGridViewCell.Value == null)
                    dataGridViewCell.Value = (object)"  ";
                if (dataGridViewCell.ColumnIndex != 10) ;
                {

                }
            }
            switch (type)
            {
                case "":
                    IEnumerator enumerator1 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator1.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator1.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                dataGridViewCell.Value = (object)"  ";
                                dataGridViewCell.Style = this.cellstyle("");
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator1 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "P":
                    IEnumerator enumerator2 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator2.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator2.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[0] = 'P';
                                if ((int)chArray[1] == 32)
                                    chArray[1] = '1';
                                dataGridViewCell.Value = (object)new string(chArray);
                                dataGridViewCell.Style = this.cellstyle("P");
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator2 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "F":
                    IEnumerator enumerator3 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator3.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator3.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[0] = 'F';
                                if ((int)chArray[1] == 32)
                                    chArray[1] = '1';
                                dataGridViewCell.Value = (object)new string(chArray);
                                dataGridViewCell.Style = this.cellstyle("F");
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator3 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "C":
                    IEnumerator enumerator4 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator4.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator4.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[0] = 'C';
                                if ((int)chArray[1] == 32)
                                    chArray[1] = '1';
                                dataGridViewCell.Value = (object)new string(chArray);
                                dataGridViewCell.Style = this.cellstyle("C");
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator4 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "E":
                    IEnumerator enumerator5 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator5.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator5.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[0] = 'E';
                                if ((int)chArray[1] == 32)
                                    chArray[1] = '1';
                                dataGridViewCell.Value = (object)new string(chArray);
                                dataGridViewCell.Style = this.cellstyle("E");
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator5 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "B":
                    IEnumerator enumerator6 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator6.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator6.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[0] = 'B';
                                if ((int)chArray[1] == 32)
                                    chArray[1] = '1';
                                dataGridViewCell.Value = (object)new string(chArray);
                                dataGridViewCell.Style = this.cellstyle("B");
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator6 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "1":
                    IEnumerator enumerator7 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator7.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator7.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[1] = '1';
                                if ((int)chArray[0] == 32)
                                {
                                    chArray[0] = 'P';
                                    dataGridViewCell.Style = this.cellstyle("P");
                                }
                                dataGridViewCell.Value = (object)new string(chArray);
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator7 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "2":
                    IEnumerator enumerator8 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator8.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator8.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[1] = '2';
                                if ((int)chArray[0] == 32)
                                {
                                    chArray[0] = 'P';
                                    dataGridViewCell.Style = this.cellstyle("P");
                                }
                                dataGridViewCell.Value = (object)new string(chArray);
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator8 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "3":
                    IEnumerator enumerator9 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator9.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator9.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[1] = '3';
                                if ((int)chArray[0] == 32)
                                {
                                    chArray[0] = 'P';
                                    dataGridViewCell.Style = this.cellstyle("P");
                                }
                                dataGridViewCell.Value = (object)new string(chArray);
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator9 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "4":
                    IEnumerator enumerator10 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator10.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator10.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[1] = '4';
                                if ((int)chArray[0] == 32)
                                {
                                    chArray[0] = 'P';
                                    dataGridViewCell.Style = this.cellstyle("P");
                                }
                                dataGridViewCell.Value = (object)new string(chArray);
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator10 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "5":
                    IEnumerator enumerator11 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator11.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator11.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[1] = '5';
                                if ((int)chArray[0] == 32)
                                {
                                    chArray[0] = 'P';
                                    dataGridViewCell.Style = this.cellstyle("P");
                                }
                                dataGridViewCell.Value = (object)new string(chArray);
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator11 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "6":
                    IEnumerator enumerator12 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator12.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator12.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[1] = '6';
                                if ((int)chArray[0] == 32)
                                {
                                    chArray[0] = 'P';
                                    dataGridViewCell.Style = this.cellstyle("P");
                                }
                                dataGridViewCell.Value = (object)new string(chArray);
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator12 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "7":
                    IEnumerator enumerator13 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator13.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator13.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[1] = '7';
                                if ((int)chArray[0] == 32)
                                {
                                    chArray[0] = 'P';
                                    dataGridViewCell.Style = this.cellstyle("P");
                                    dataGridViewCell.Value = (object)new string(chArray);
                                }
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator13 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "8":
                    IEnumerator enumerator14 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator14.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator14.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[1] = '8';
                                if ((int)chArray[0] == 32)
                                {
                                    chArray[0] = 'P';
                                    dataGridViewCell.Style = this.cellstyle("P");
                                }
                                dataGridViewCell.Value = (object)new string(chArray);
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator14 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
                case "9":
                    IEnumerator enumerator15 = dgv.SelectedCells.GetEnumerator();
                    try
                    {
                        while (enumerator15.MoveNext())
                        {
                            DataGridViewCell dataGridViewCell = (DataGridViewCell)enumerator15.Current;
                            if (dataGridViewCell.ColumnIndex != 10)
                            {
                                char[] chArray = dataGridViewCell.Value.ToString().ToCharArray();
                                chArray[1] = '9';
                                if ((int)chArray[0] == 32)
                                {
                                    chArray[0] = 'P';
                                    dataGridViewCell.Style = this.cellstyle("P");
                                }
                                dataGridViewCell.Value = (object)new string(chArray);
                            }
                        }
                        break;
                    }
                    finally
                    {
                        IDisposable disposable = enumerator15 as IDisposable;
                        if (disposable != null)
                            disposable.Dispose();
                    }
            }
        }

        public void saveChanges(ListView lvw, DataGridView dgv, ComboBox cbx, TextBox txt)
        {
            lvw.SelectedItems[0].Tag = (object)"";
            lvw.SelectedItems[0].Tag = (object)(cbx.Text + ";" + txt.Text + "\n");
            foreach (DataGridViewRow dataGridViewRow in (IEnumerable)dgv.Rows)
            {
                if (!dataGridViewRow.IsNewRow)
                {
                    foreach (DataGridViewCell dataGridViewCell in (BaseCollection)dataGridViewRow.Cells)
                    {
                        if (dataGridViewCell.Value == null)
                            dataGridViewCell.Value = (object)"  ";
                    }
                    ListViewItem listViewItem = lvw.SelectedItems[0];
                    string str = (string)listViewItem.Tag + (object)"|" + (string)dataGridViewRow.Cells[0].Value + "|" + (string)dataGridViewRow.Cells[1].Value + "|" + (string)dataGridViewRow.Cells[2].Value + "|" + (string)dataGridViewRow.Cells[3].Value + "|" + (string)dataGridViewRow.Cells[4].Value + "|" + (string)dataGridViewRow.Cells[5].Value + "|" + (string)dataGridViewRow.Cells[6].Value + "|" + (string)dataGridViewRow.Cells[7].Value + "|" + (string)dataGridViewRow.Cells[8].Value + "|" + (string)dataGridViewRow.Cells[9].Value + "|" + (string)dataGridViewRow.Cells[10].Value + "\n";
                    listViewItem.Tag = (object)str;
                }
            }
        }

        public void buildLua(string luapath, ListView lvw)
        {
            luapath = luapath + "_";
            File.WriteAllText(luapath, "");
            using (StreamWriter streamWriter = File.AppendText(luapath))
            {
                streamWriter.WriteLine("return {\n");
                foreach (ListViewItem listViewItem in lvw.Items)
                {
                    int num1 = (int)MessageBox.Show(listViewItem.Tag.ToString());
                    int length = listViewItem.Tag.ToString().IndexOf('\n');
                    string str1 = listViewItem.Tag.ToString().Substring(length + 1);
                    string str2 = "{name = \"" + listViewItem.Text + "\"";
                    int num2 = (int)MessageBox.Show(listViewItem.Tag.ToString().Substring(0, length));
                    if (listViewItem.Tag.ToString().Substring(0, length).Split(new char[1]
          {
            ';'
          })[0] == "true")
                        str2 = str2 + ", noenergy = true";
                    if (!(listViewItem.Tag.ToString().Substring(0, length).Split(new char[1]
          {
            ';'
          })[0] == ""))
                        str2 = str2 + ", stages = {" + listViewItem.Tag.ToString().Substring(0, length).Split(new char[1]
            {
              ';'
            })[0] + "}";
                    string text = str2 + ", [[";
                    int num3 = (int)MessageBox.Show(text);
                    streamWriter.WriteLine(text);
                    streamWriter.Write(str1);
                    streamWriter.WriteLine("]]},");
                }
                streamWriter.WriteLine("}");
            }
        }

        public DataGridViewCellStyle cellstyle(string type)
        {
            DataGridViewCellStyle gridViewCellStyle = new DataGridViewCellStyle();
            switch (type)
            {
                case "P":
                    gridViewCellStyle.BackColor = Color.Gray;
                    gridViewCellStyle.ForeColor = Color.White;
                    return gridViewCellStyle;
                case "F":
                    gridViewCellStyle.BackColor = Color.Orange;
                    gridViewCellStyle.ForeColor = Color.Black;
                    return gridViewCellStyle;
                case "C":
                    gridViewCellStyle.BackColor = Color.DarkRed;
                    gridViewCellStyle.ForeColor = Color.White;
                    return gridViewCellStyle;
                case "E":
                    gridViewCellStyle.BackColor = Color.LightBlue;
                    gridViewCellStyle.ForeColor = Color.Black;
                    return gridViewCellStyle;
                case "B":
                    gridViewCellStyle.BackColor = Color.DarkGray;
                    gridViewCellStyle.ForeColor = Color.White;
                    return gridViewCellStyle;
                default:
                    gridViewCellStyle.BackColor = Color.White;
                    gridViewCellStyle.ForeColor = Color.Black;
                    return gridViewCellStyle;
            }
        }
    }
}