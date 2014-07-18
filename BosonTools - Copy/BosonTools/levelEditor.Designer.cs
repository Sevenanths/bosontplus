namespace BosonTools
{
    partial class frmLevelEditor
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.txtGamePath = new System.Windows.Forms.TextBox();
            this.btnBrowseGamePath = new System.Windows.Forms.Button();
            this.pnlOptions = new System.Windows.Forms.Panel();
            this.panel1 = new System.Windows.Forms.Panel();
            this.btnDebugParseNouveau = new System.Windows.Forms.Button();
            this.btnDebugParse = new System.Windows.Forms.Button();
            this.cbxStages = new System.Windows.Forms.ComboBox();
            this.dgvLevelEdit = new System.Windows.Forms.DataGridView();
            this.clm1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.clm2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.clm3 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.clm4 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.clm5 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.clm6 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.clm7 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.clm8 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.clm9 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.clm10 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.clmDataTags = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.cmsPlatformTypes = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.toolStripMenuItemType = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItemAir = new System.Windows.Forms.ToolStripMenuItem();
            this.normalPToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.fastFToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.collapsingCToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.energyEToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.barrierBToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItemSeperator = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripMenuItemAltitude = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem2 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem3 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem4 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem5 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem6 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem7 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem8 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem9 = new System.Windows.Forms.ToolStripMenuItem();
            this.lvwSections = new System.Windows.Forms.ListView();
            this.cmsSections = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.removeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.txtSectionAdd = new System.Windows.Forms.TextBox();
            this.btnSectionAdd = new System.Windows.Forms.Button();
            this.pnlButtons = new System.Windows.Forms.Panel();
            this.btnRemoveRow = new System.Windows.Forms.Button();
            this.btnInsertRow = new System.Windows.Forms.Button();
            this.btnSaveChanges = new System.Windows.Forms.Button();
            this.pnlOptions.SuspendLayout();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvLevelEdit)).BeginInit();
            this.cmsPlatformTypes.SuspendLayout();
            this.cmsSections.SuspendLayout();
            this.pnlButtons.SuspendLayout();
            this.SuspendLayout();
            // 
            // txtGamePath
            // 
            this.txtGamePath.Location = new System.Drawing.Point(19, 15);
            this.txtGamePath.Name = "txtGamePath";
            this.txtGamePath.ReadOnly = true;
            this.txtGamePath.Size = new System.Drawing.Size(133, 20);
            this.txtGamePath.TabIndex = 0;
            this.txtGamePath.Text = "<gamespath>";
            this.txtGamePath.TextChanged += new System.EventHandler(this.txtGamePath_TextChanged);
            // 
            // btnBrowseGamePath
            // 
            this.btnBrowseGamePath.Location = new System.Drawing.Point(156, 14);
            this.btnBrowseGamePath.Name = "btnBrowseGamePath";
            this.btnBrowseGamePath.Size = new System.Drawing.Size(75, 22);
            this.btnBrowseGamePath.TabIndex = 1;
            this.btnBrowseGamePath.Text = "Browse";
            this.btnBrowseGamePath.UseVisualStyleBackColor = true;
            this.btnBrowseGamePath.Click += new System.EventHandler(this.btnBrowseGamePath_Click);
            // 
            // pnlOptions
            // 
            this.pnlOptions.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlOptions.Controls.Add(this.panel1);
            this.pnlOptions.Controls.Add(this.txtGamePath);
            this.pnlOptions.Controls.Add(this.btnBrowseGamePath);
            this.pnlOptions.Location = new System.Drawing.Point(-8, -4);
            this.pnlOptions.Name = "pnlOptions";
            this.pnlOptions.Size = new System.Drawing.Size(948, 48);
            this.pnlOptions.TabIndex = 2;
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.btnDebugParseNouveau);
            this.panel1.Controls.Add(this.btnDebugParse);
            this.panel1.Controls.Add(this.cbxStages);
            this.panel1.Location = new System.Drawing.Point(237, 4);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(710, 43);
            this.panel1.TabIndex = 4;
            // 
            // btnDebugParseNouveau
            // 
            this.btnDebugParseNouveau.Location = new System.Drawing.Point(236, 8);
            this.btnDebugParseNouveau.Name = "btnDebugParseNouveau";
            this.btnDebugParseNouveau.Size = new System.Drawing.Size(75, 23);
            this.btnDebugParseNouveau.TabIndex = 5;
            this.btnDebugParseNouveau.Text = "debugparse";
            this.btnDebugParseNouveau.UseVisualStyleBackColor = true;
            this.btnDebugParseNouveau.Click += new System.EventHandler(this.btnDebugParseNouveau_Click);
            // 
            // btnDebugParse
            // 
            this.btnDebugParse.Location = new System.Drawing.Point(400, 9);
            this.btnDebugParse.Name = "btnDebugParse";
            this.btnDebugParse.Size = new System.Drawing.Size(75, 23);
            this.btnDebugParse.TabIndex = 4;
            this.btnDebugParse.Text = "debugparse";
            this.btnDebugParse.UseVisualStyleBackColor = true;
            this.btnDebugParse.Click += new System.EventHandler(this.btnDebugParse_Click);
            // 
            // cbxStages
            // 
            this.cbxStages.FormattingEnabled = true;
            this.cbxStages.Items.AddRange(new object[] {
            "stage 1",
            "stage 2",
            "stage 3",
            "stage 4",
            "stage 5",
            "stage 6"});
            this.cbxStages.Location = new System.Drawing.Point(3, 11);
            this.cbxStages.Name = "cbxStages";
            this.cbxStages.Size = new System.Drawing.Size(121, 21);
            this.cbxStages.TabIndex = 3;
            this.cbxStages.SelectedIndexChanged += new System.EventHandler(this.cbxStages_SelectedIndexChanged);
            // 
            // dgvLevelEdit
            // 
            this.dgvLevelEdit.AllowUserToResizeColumns = false;
            this.dgvLevelEdit.AllowUserToResizeRows = false;
            this.dgvLevelEdit.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.dgvLevelEdit.ColumnHeadersHeight = 18;
            this.dgvLevelEdit.ColumnHeadersVisible = false;
            this.dgvLevelEdit.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.clm1,
            this.clm2,
            this.clm3,
            this.clm4,
            this.clm5,
            this.clm6,
            this.clm7,
            this.clm8,
            this.clm9,
            this.clm10,
            this.clmDataTags});
            this.dgvLevelEdit.ContextMenuStrip = this.cmsPlatformTypes;
            this.dgvLevelEdit.Location = new System.Drawing.Point(141, 51);
            this.dgvLevelEdit.Name = "dgvLevelEdit";
            this.dgvLevelEdit.RowHeadersWidth = 10;
            this.dgvLevelEdit.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            this.dgvLevelEdit.Size = new System.Drawing.Size(650, 368);
            this.dgvLevelEdit.TabIndex = 5;
            this.dgvLevelEdit.CellMouseClick += new System.Windows.Forms.DataGridViewCellMouseEventHandler(this.dgvLevelEdit_CellMouseClick);
            // 
            // clm1
            // 
            this.clm1.FillWeight = 51.45118F;
            this.clm1.HeaderText = "";
            this.clm1.MaxInputLength = 2;
            this.clm1.Name = "clm1";
            this.clm1.ReadOnly = true;
            this.clm1.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.clm1.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.clm1.Width = 50;
            // 
            // clm2
            // 
            this.clm2.FillWeight = 63.78923F;
            this.clm2.HeaderText = "";
            this.clm2.MaxInputLength = 2;
            this.clm2.Name = "clm2";
            this.clm2.ReadOnly = true;
            this.clm2.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.clm2.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.clm2.Width = 50;
            // 
            // clm3
            // 
            this.clm3.FillWeight = 75.49246F;
            this.clm3.HeaderText = "";
            this.clm3.MaxInputLength = 2;
            this.clm3.Name = "clm3";
            this.clm3.ReadOnly = true;
            this.clm3.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.clm3.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.clm3.Width = 50;
            // 
            // clm4
            // 
            this.clm4.FillWeight = 86.59356F;
            this.clm4.HeaderText = "";
            this.clm4.MaxInputLength = 2;
            this.clm4.Name = "clm4";
            this.clm4.ReadOnly = true;
            this.clm4.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.clm4.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.clm4.Width = 50;
            // 
            // clm5
            // 
            this.clm5.FillWeight = 97.12348F;
            this.clm5.HeaderText = "";
            this.clm5.MaxInputLength = 2;
            this.clm5.Name = "clm5";
            this.clm5.ReadOnly = true;
            this.clm5.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.clm5.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.clm5.Width = 50;
            // 
            // clm6
            // 
            this.clm6.FillWeight = 107.1116F;
            this.clm6.HeaderText = "";
            this.clm6.MaxInputLength = 2;
            this.clm6.Name = "clm6";
            this.clm6.ReadOnly = true;
            this.clm6.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.clm6.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.clm6.Width = 50;
            // 
            // clm7
            // 
            this.clm7.FillWeight = 116.5859F;
            this.clm7.HeaderText = "";
            this.clm7.MaxInputLength = 2;
            this.clm7.Name = "clm7";
            this.clm7.ReadOnly = true;
            this.clm7.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.clm7.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.clm7.Width = 50;
            // 
            // clm8
            // 
            this.clm8.FillWeight = 125.5726F;
            this.clm8.HeaderText = "";
            this.clm8.MaxInputLength = 2;
            this.clm8.Name = "clm8";
            this.clm8.ReadOnly = true;
            this.clm8.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.clm8.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.clm8.Width = 50;
            // 
            // clm9
            // 
            this.clm9.FillWeight = 134.097F;
            this.clm9.HeaderText = "";
            this.clm9.MaxInputLength = 2;
            this.clm9.Name = "clm9";
            this.clm9.ReadOnly = true;
            this.clm9.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.clm9.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.clm9.Width = 50;
            // 
            // clm10
            // 
            this.clm10.FillWeight = 142.1829F;
            this.clm10.HeaderText = "";
            this.clm10.MaxInputLength = 2;
            this.clm10.Name = "clm10";
            this.clm10.ReadOnly = true;
            this.clm10.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.clm10.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            this.clm10.Width = 50;
            // 
            // clmDataTags
            // 
            this.clmDataTags.HeaderText = "";
            this.clmDataTags.Name = "clmDataTags";
            // 
            // cmsPlatformTypes
            // 
            this.cmsPlatformTypes.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripMenuItemType,
            this.toolStripMenuItemAir,
            this.normalPToolStripMenuItem,
            this.fastFToolStripMenuItem,
            this.collapsingCToolStripMenuItem,
            this.energyEToolStripMenuItem,
            this.barrierBToolStripMenuItem,
            this.toolStripMenuItemSeperator,
            this.toolStripMenuItemAltitude,
            this.toolStripMenuItem1,
            this.toolStripMenuItem2,
            this.toolStripMenuItem3,
            this.toolStripMenuItem4,
            this.toolStripMenuItem5,
            this.toolStripMenuItem6,
            this.toolStripMenuItem7,
            this.toolStripMenuItem8,
            this.toolStripMenuItem9});
            this.cmsPlatformTypes.Name = "cmsPlatformTypes";
            this.cmsPlatformTypes.Size = new System.Drawing.Size(150, 384);
            // 
            // toolStripMenuItemType
            // 
            this.toolStripMenuItemType.Enabled = false;
            this.toolStripMenuItemType.Name = "toolStripMenuItemType";
            this.toolStripMenuItemType.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItemType.Text = "TYPE";
            // 
            // toolStripMenuItemAir
            // 
            this.toolStripMenuItemAir.Name = "toolStripMenuItemAir";
            this.toolStripMenuItemAir.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItemAir.Text = "Air (  )";
            this.toolStripMenuItemAir.Click += new System.EventHandler(this.toolStripMenuItemAir_Click);
            // 
            // normalPToolStripMenuItem
            // 
            this.normalPToolStripMenuItem.Name = "normalPToolStripMenuItem";
            this.normalPToolStripMenuItem.Size = new System.Drawing.Size(149, 22);
            this.normalPToolStripMenuItem.Text = "Normal (P)";
            this.normalPToolStripMenuItem.Click += new System.EventHandler(this.normalPToolStripMenuItem_Click);
            // 
            // fastFToolStripMenuItem
            // 
            this.fastFToolStripMenuItem.Name = "fastFToolStripMenuItem";
            this.fastFToolStripMenuItem.Size = new System.Drawing.Size(149, 22);
            this.fastFToolStripMenuItem.Text = "Fast (F)";
            this.fastFToolStripMenuItem.Click += new System.EventHandler(this.fastFToolStripMenuItem_Click);
            // 
            // collapsingCToolStripMenuItem
            // 
            this.collapsingCToolStripMenuItem.Name = "collapsingCToolStripMenuItem";
            this.collapsingCToolStripMenuItem.Size = new System.Drawing.Size(149, 22);
            this.collapsingCToolStripMenuItem.Text = "Collapsing (C)";
            this.collapsingCToolStripMenuItem.Click += new System.EventHandler(this.collapsingCToolStripMenuItem_Click);
            // 
            // energyEToolStripMenuItem
            // 
            this.energyEToolStripMenuItem.Name = "energyEToolStripMenuItem";
            this.energyEToolStripMenuItem.Size = new System.Drawing.Size(149, 22);
            this.energyEToolStripMenuItem.Text = "Energy (E)";
            this.energyEToolStripMenuItem.Click += new System.EventHandler(this.energyEToolStripMenuItem_Click);
            // 
            // barrierBToolStripMenuItem
            // 
            this.barrierBToolStripMenuItem.Name = "barrierBToolStripMenuItem";
            this.barrierBToolStripMenuItem.Size = new System.Drawing.Size(149, 22);
            this.barrierBToolStripMenuItem.Text = "Barrier (B)";
            this.barrierBToolStripMenuItem.Click += new System.EventHandler(this.barrierBToolStripMenuItem_Click);
            // 
            // toolStripMenuItemSeperator
            // 
            this.toolStripMenuItemSeperator.Name = "toolStripMenuItemSeperator";
            this.toolStripMenuItemSeperator.Size = new System.Drawing.Size(146, 6);
            // 
            // toolStripMenuItemAltitude
            // 
            this.toolStripMenuItemAltitude.Enabled = false;
            this.toolStripMenuItemAltitude.Name = "toolStripMenuItemAltitude";
            this.toolStripMenuItemAltitude.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItemAltitude.Text = "ALTITUDE";
            // 
            // toolStripMenuItem1
            // 
            this.toolStripMenuItem1.Name = "toolStripMenuItem1";
            this.toolStripMenuItem1.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItem1.Text = "1";
            this.toolStripMenuItem1.Click += new System.EventHandler(this.toolStripMenuItem1_Click);
            // 
            // toolStripMenuItem2
            // 
            this.toolStripMenuItem2.Name = "toolStripMenuItem2";
            this.toolStripMenuItem2.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItem2.Text = "2";
            this.toolStripMenuItem2.Click += new System.EventHandler(this.toolStripMenuItem2_Click);
            // 
            // toolStripMenuItem3
            // 
            this.toolStripMenuItem3.Name = "toolStripMenuItem3";
            this.toolStripMenuItem3.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItem3.Text = "3";
            this.toolStripMenuItem3.Click += new System.EventHandler(this.toolStripMenuItem3_Click);
            // 
            // toolStripMenuItem4
            // 
            this.toolStripMenuItem4.Name = "toolStripMenuItem4";
            this.toolStripMenuItem4.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItem4.Text = "4";
            this.toolStripMenuItem4.Click += new System.EventHandler(this.toolStripMenuItem4_Click);
            // 
            // toolStripMenuItem5
            // 
            this.toolStripMenuItem5.Name = "toolStripMenuItem5";
            this.toolStripMenuItem5.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItem5.Text = "5";
            this.toolStripMenuItem5.Click += new System.EventHandler(this.toolStripMenuItem5_Click);
            // 
            // toolStripMenuItem6
            // 
            this.toolStripMenuItem6.Name = "toolStripMenuItem6";
            this.toolStripMenuItem6.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItem6.Text = "6";
            this.toolStripMenuItem6.Click += new System.EventHandler(this.toolStripMenuItem6_Click);
            // 
            // toolStripMenuItem7
            // 
            this.toolStripMenuItem7.Name = "toolStripMenuItem7";
            this.toolStripMenuItem7.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItem7.Text = "7";
            this.toolStripMenuItem7.Click += new System.EventHandler(this.toolStripMenuItem7_Click);
            // 
            // toolStripMenuItem8
            // 
            this.toolStripMenuItem8.Name = "toolStripMenuItem8";
            this.toolStripMenuItem8.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItem8.Text = "8";
            this.toolStripMenuItem8.Click += new System.EventHandler(this.toolStripMenuItem8_Click);
            // 
            // toolStripMenuItem9
            // 
            this.toolStripMenuItem9.Name = "toolStripMenuItem9";
            this.toolStripMenuItem9.Size = new System.Drawing.Size(149, 22);
            this.toolStripMenuItem9.Text = "9";
            this.toolStripMenuItem9.Click += new System.EventHandler(this.toolStripMenuItem9_Click);
            // 
            // lvwSections
            // 
            this.lvwSections.ContextMenuStrip = this.cmsSections;
            this.lvwSections.HideSelection = false;
            this.lvwSections.Location = new System.Drawing.Point(12, 50);
            this.lvwSections.Name = "lvwSections";
            this.lvwSections.Size = new System.Drawing.Size(121, 343);
            this.lvwSections.TabIndex = 6;
            this.lvwSections.UseCompatibleStateImageBehavior = false;
            this.lvwSections.View = System.Windows.Forms.View.SmallIcon;
            this.lvwSections.SelectedIndexChanged += new System.EventHandler(this.lvwSections_SelectedIndexChanged);
            // 
            // cmsSections
            // 
            this.cmsSections.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.removeToolStripMenuItem});
            this.cmsSections.Name = "cmsSections";
            this.cmsSections.Size = new System.Drawing.Size(118, 26);
            // 
            // removeToolStripMenuItem
            // 
            this.removeToolStripMenuItem.Name = "removeToolStripMenuItem";
            this.removeToolStripMenuItem.Size = new System.Drawing.Size(117, 22);
            this.removeToolStripMenuItem.Text = "Remove";
            this.removeToolStripMenuItem.Click += new System.EventHandler(this.removeToolStripMenuItem_Click);
            // 
            // txtSectionAdd
            // 
            this.txtSectionAdd.Location = new System.Drawing.Point(12, 399);
            this.txtSectionAdd.Name = "txtSectionAdd";
            this.txtSectionAdd.Size = new System.Drawing.Size(98, 20);
            this.txtSectionAdd.TabIndex = 7;
            this.txtSectionAdd.TextChanged += new System.EventHandler(this.txtSectionAdd_TextChanged);
            // 
            // btnSectionAdd
            // 
            this.btnSectionAdd.Location = new System.Drawing.Point(112, 398);
            this.btnSectionAdd.Name = "btnSectionAdd";
            this.btnSectionAdd.Size = new System.Drawing.Size(22, 22);
            this.btnSectionAdd.TabIndex = 8;
            this.btnSectionAdd.UseVisualStyleBackColor = true;
            this.btnSectionAdd.Click += new System.EventHandler(this.btnSectionAdd_Click);
            // 
            // pnlButtons
            // 
            this.pnlButtons.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlButtons.Controls.Add(this.btnSaveChanges);
            this.pnlButtons.Controls.Add(this.btnRemoveRow);
            this.pnlButtons.Controls.Add(this.btnInsertRow);
            this.pnlButtons.Location = new System.Drawing.Point(797, 51);
            this.pnlButtons.Name = "pnlButtons";
            this.pnlButtons.Size = new System.Drawing.Size(121, 368);
            this.pnlButtons.TabIndex = 9;
            // 
            // btnRemoveRow
            // 
            this.btnRemoveRow.Location = new System.Drawing.Point(3, 342);
            this.btnRemoveRow.Name = "btnRemoveRow";
            this.btnRemoveRow.Size = new System.Drawing.Size(113, 23);
            this.btnRemoveRow.TabIndex = 1;
            this.btnRemoveRow.Text = "Remove selc rows";
            this.btnRemoveRow.UseVisualStyleBackColor = true;
            this.btnRemoveRow.Click += new System.EventHandler(this.btnRemoveRow_Click);
            // 
            // btnInsertRow
            // 
            this.btnInsertRow.Location = new System.Drawing.Point(3, 319);
            this.btnInsertRow.Name = "btnInsertRow";
            this.btnInsertRow.Size = new System.Drawing.Size(113, 23);
            this.btnInsertRow.TabIndex = 0;
            this.btnInsertRow.Text = "Insert row";
            this.btnInsertRow.UseVisualStyleBackColor = true;
            this.btnInsertRow.Click += new System.EventHandler(this.btnInsertRow_Click);
            // 
            // btnSaveChanges
            // 
            this.btnSaveChanges.Location = new System.Drawing.Point(3, 3);
            this.btnSaveChanges.Name = "btnSaveChanges";
            this.btnSaveChanges.Size = new System.Drawing.Size(113, 23);
            this.btnSaveChanges.TabIndex = 2;
            this.btnSaveChanges.Text = "Save changes";
            this.btnSaveChanges.UseVisualStyleBackColor = true;
            this.btnSaveChanges.Click += new System.EventHandler(this.btnSaveChanges_Click);
            // 
            // frmLevelEditor
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.ClientSize = new System.Drawing.Size(929, 431);
            this.Controls.Add(this.pnlButtons);
            this.Controls.Add(this.btnSectionAdd);
            this.Controls.Add(this.txtSectionAdd);
            this.Controls.Add(this.lvwSections);
            this.Controls.Add(this.dgvLevelEdit);
            this.Controls.Add(this.pnlOptions);
            this.Name = "frmLevelEditor";
            this.Text = "Boson-T :: level editor";
            this.Load += new System.EventHandler(this.frmLevelEditor_Load);
            this.pnlOptions.ResumeLayout(false);
            this.pnlOptions.PerformLayout();
            this.panel1.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvLevelEdit)).EndInit();
            this.cmsPlatformTypes.ResumeLayout(false);
            this.cmsSections.ResumeLayout(false);
            this.pnlButtons.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox txtGamePath;
        private System.Windows.Forms.Button btnBrowseGamePath;
        private System.Windows.Forms.Panel pnlOptions;
        private System.Windows.Forms.ComboBox cbxStages;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button btnDebugParse;
        private System.Windows.Forms.DataGridView dgvLevelEdit;
        private System.Windows.Forms.ListView lvwSections;
        private System.Windows.Forms.TextBox txtSectionAdd;
        private System.Windows.Forms.Button btnSectionAdd;
        private System.Windows.Forms.ContextMenuStrip cmsSections;
        private System.Windows.Forms.ToolStripMenuItem removeToolStripMenuItem;
        private System.Windows.Forms.Button btnDebugParseNouveau;
        private System.Windows.Forms.ContextMenuStrip cmsPlatformTypes;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItemType;
        private System.Windows.Forms.ToolStripMenuItem normalPToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem fastFToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem collapsingCToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem energyEToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem barrierBToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripMenuItemSeperator;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItemAltitude;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem2;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem3;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem4;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem5;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem6;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem7;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem8;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem9;
        private System.Windows.Forms.DataGridViewTextBoxColumn clm1;
        private System.Windows.Forms.DataGridViewTextBoxColumn clm2;
        private System.Windows.Forms.DataGridViewTextBoxColumn clm3;
        private System.Windows.Forms.DataGridViewTextBoxColumn clm4;
        private System.Windows.Forms.DataGridViewTextBoxColumn clm5;
        private System.Windows.Forms.DataGridViewTextBoxColumn clm6;
        private System.Windows.Forms.DataGridViewTextBoxColumn clm7;
        private System.Windows.Forms.DataGridViewTextBoxColumn clm8;
        private System.Windows.Forms.DataGridViewTextBoxColumn clm9;
        private System.Windows.Forms.DataGridViewTextBoxColumn clm10;
        private System.Windows.Forms.DataGridViewTextBoxColumn clmDataTags;
        private System.Windows.Forms.Panel pnlButtons;
        private System.Windows.Forms.Button btnInsertRow;
        private System.Windows.Forms.Button btnRemoveRow;
        private System.Windows.Forms.ToolStripMenuItem toolStripMenuItemAir;
        private System.Windows.Forms.Button btnSaveChanges;
    }
}

