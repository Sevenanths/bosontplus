namespace BosonTools
{
    partial class bgEditor
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(bgEditor));
            this.cbxStageSelect = new System.Windows.Forms.ComboBox();
            this.btnSaveChanges = new System.Windows.Forms.Button();
            this.pnlBg = new System.Windows.Forms.Panel();
            this.pbxErik = new System.Windows.Forms.PictureBox();
            this.lvwSections = new System.Windows.Forms.ListView();
            this.cbbDiffuse = new System.Windows.Forms.CheckBox();
            this.pnlEdit = new System.Windows.Forms.Panel();
            this.LblColour = new System.Windows.Forms.LinkLabel();
            this.lblDeclColour = new System.Windows.Forms.Label();
            this.txtValue = new System.Windows.Forms.TextBox();
            this.pnlBg.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pbxErik)).BeginInit();
            this.pnlEdit.SuspendLayout();
            this.SuspendLayout();
            // 
            // cbxStageSelect
            // 
            this.cbxStageSelect.FormattingEnabled = true;
            this.cbxStageSelect.Items.AddRange(new object[] {
            "stage 1",
            "stage 2",
            "stage 3",
            "stage 4",
            "stage 5",
            "stage 6"});
            this.cbxStageSelect.Location = new System.Drawing.Point(12, 12);
            this.cbxStageSelect.Name = "cbxStageSelect";
            this.cbxStageSelect.Size = new System.Drawing.Size(129, 21);
            this.cbxStageSelect.TabIndex = 1;
            this.cbxStageSelect.SelectedIndexChanged += new System.EventHandler(this.cbxStageSelect_SelectedIndexChanged);
            // 
            // btnSaveChanges
            // 
            this.btnSaveChanges.Location = new System.Drawing.Point(147, 11);
            this.btnSaveChanges.Name = "btnSaveChanges";
            this.btnSaveChanges.Size = new System.Drawing.Size(113, 23);
            this.btnSaveChanges.TabIndex = 14;
            this.btnSaveChanges.Text = "Save changes";
            this.btnSaveChanges.UseVisualStyleBackColor = true;
            // 
            // pnlBg
            // 
            this.pnlBg.BackColor = System.Drawing.Color.Transparent;
            this.pnlBg.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.pnlBg.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlBg.Controls.Add(this.pbxErik);
            this.pnlBg.Location = new System.Drawing.Point(147, 40);
            this.pnlBg.Name = "pnlBg";
            this.pnlBg.Size = new System.Drawing.Size(601, 338);
            this.pnlBg.TabIndex = 15;
            this.pnlBg.Paint += new System.Windows.Forms.PaintEventHandler(this.pnlBgEdit_Paint);
            // 
            // pbxErik
            // 
            this.pbxErik.BackColor = System.Drawing.Color.Transparent;
            this.pbxErik.Image = ((System.Drawing.Image)(resources.GetObject("pbxErik.Image")));
            this.pbxErik.Location = new System.Drawing.Point(250, 194);
            this.pbxErik.Name = "pbxErik";
            this.pbxErik.Size = new System.Drawing.Size(98, 135);
            this.pbxErik.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pbxErik.TabIndex = 0;
            this.pbxErik.TabStop = false;
            // 
            // lvwSections
            // 
            this.lvwSections.HideSelection = false;
            this.lvwSections.Location = new System.Drawing.Point(12, 39);
            this.lvwSections.Name = "lvwSections";
            this.lvwSections.Size = new System.Drawing.Size(129, 339);
            this.lvwSections.TabIndex = 2;
            this.lvwSections.UseCompatibleStateImageBehavior = false;
            this.lvwSections.View = System.Windows.Forms.View.SmallIcon;
            this.lvwSections.SelectedIndexChanged += new System.EventHandler(this.lvwSections_SelectedIndexChanged);
            // 
            // cbbDiffuse
            // 
            this.cbbDiffuse.AutoSize = true;
            this.cbbDiffuse.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.cbbDiffuse.Location = new System.Drawing.Point(686, 20);
            this.cbbDiffuse.Name = "cbbDiffuse";
            this.cbbDiffuse.Size = new System.Drawing.Size(63, 17);
            this.cbbDiffuse.TabIndex = 16;
            this.cbbDiffuse.Text = "Diffuse";
            this.cbbDiffuse.UseVisualStyleBackColor = true;
            // 
            // pnlEdit
            // 
            this.pnlEdit.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlEdit.Controls.Add(this.lblDeclColour);
            this.pnlEdit.Controls.Add(this.LblColour);
            this.pnlEdit.Controls.Add(this.txtValue);
            this.pnlEdit.Location = new System.Drawing.Point(754, 40);
            this.pnlEdit.Name = "pnlEdit";
            this.pnlEdit.Size = new System.Drawing.Size(129, 339);
            this.pnlEdit.TabIndex = 17;
            // 
            // LblColour
            // 
            this.LblColour.AutoSize = true;
            this.LblColour.Font = new System.Drawing.Font("Segoe UI", 13.25F);
            this.LblColour.LinkColor = System.Drawing.Color.White;
            this.LblColour.Location = new System.Drawing.Point(4, 2);
            this.LblColour.Name = "LblColour";
            this.LblColour.Size = new System.Drawing.Size(120, 25);
            this.LblColour.TabIndex = 18;
            this.LblColour.TabStop = true;
            this.LblColour.Text = "213, 123, 123";
            this.LblColour.Visible = false;
            // 
            // lblDeclColour
            // 
            this.lblDeclColour.AutoSize = true;
            this.lblDeclColour.ForeColor = System.Drawing.Color.Gainsboro;
            this.lblDeclColour.Location = new System.Drawing.Point(18, 27);
            this.lblDeclColour.Name = "lblDeclColour";
            this.lblDeclColour.Size = new System.Drawing.Size(84, 13);
            this.lblDeclColour.TabIndex = 19;
            this.lblDeclColour.Text = "(click to adjust)";
            this.lblDeclColour.Visible = false;
            // 
            // txtValue
            // 
            this.txtValue.Location = new System.Drawing.Point(3, 5);
            this.txtValue.Name = "txtValue";
            this.txtValue.Size = new System.Drawing.Size(120, 22);
            this.txtValue.TabIndex = 18;
            this.txtValue.Visible = false;
            // 
            // bgEditor
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.ClientSize = new System.Drawing.Size(895, 390);
            this.Controls.Add(this.pnlEdit);
            this.Controls.Add(this.cbbDiffuse);
            this.Controls.Add(this.lvwSections);
            this.Controls.Add(this.pnlBg);
            this.Controls.Add(this.btnSaveChanges);
            this.Controls.Add(this.cbxStageSelect);
            this.Font = new System.Drawing.Font("Segoe UI", 8.25F);
            this.Name = "bgEditor";
            this.Text = "bgEditor";
            this.Load += new System.EventHandler(this.bgEditor_Load);
            this.pnlBg.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pbxErik)).EndInit();
            this.pnlEdit.ResumeLayout(false);
            this.pnlEdit.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ComboBox cbxStageSelect;
        private System.Windows.Forms.Button btnSaveChanges;
        private System.Windows.Forms.Panel pnlBg;
        private System.Windows.Forms.ListView lvwSections;
        private System.Windows.Forms.PictureBox pbxErik;
        private System.Windows.Forms.CheckBox cbbDiffuse;
        private System.Windows.Forms.Panel pnlEdit;
        private System.Windows.Forms.Label lblDeclColour;
        private System.Windows.Forms.LinkLabel LblColour;
        private System.Windows.Forms.TextBox txtValue;
    }
}