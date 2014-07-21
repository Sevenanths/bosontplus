namespace BosonTools
{
    partial class frmMain
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmMain));
            this.pbxLogo = new System.Windows.Forms.PictureBox();
            this.btnPatternEdit = new System.Windows.Forms.Button();
            this.pnlTop = new System.Windows.Forms.Panel();
            this.btnBrowseGamePath = new System.Windows.Forms.Button();
            this.txtGamePath = new System.Windows.Forms.TextBox();
            this.pnlButtons = new System.Windows.Forms.Panel();
            this.btnAndroid = new System.Windows.Forms.Button();
            this.button1 = new System.Windows.Forms.Button();
            this.btnResource = new System.Windows.Forms.Button();
            this.button2 = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.pbxLogo)).BeginInit();
            this.pnlTop.SuspendLayout();
            this.pnlButtons.SuspendLayout();
            this.SuspendLayout();
            // 
            // pbxLogo
            // 
            this.pbxLogo.Image = ((System.Drawing.Image)(resources.GetObject("pbxLogo.Image")));
            this.pbxLogo.Location = new System.Drawing.Point(15, 12);
            this.pbxLogo.Name = "pbxLogo";
            this.pbxLogo.Size = new System.Drawing.Size(214, 27);
            this.pbxLogo.TabIndex = 0;
            this.pbxLogo.TabStop = false;
            // 
            // btnPatternEdit
            // 
            this.btnPatternEdit.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnPatternEdit.BackgroundImage")));
            this.btnPatternEdit.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.btnPatternEdit.Font = new System.Drawing.Font("Segoe UI", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnPatternEdit.ForeColor = System.Drawing.Color.White;
            this.btnPatternEdit.Location = new System.Drawing.Point(14, 15);
            this.btnPatternEdit.Name = "btnPatternEdit";
            this.btnPatternEdit.Size = new System.Drawing.Size(214, 74);
            this.btnPatternEdit.TabIndex = 1;
            this.btnPatternEdit.Text = "EDIT PATTERNS";
            this.btnPatternEdit.UseVisualStyleBackColor = true;
            this.btnPatternEdit.Click += new System.EventHandler(this.btnPatternEdit_Click);
            // 
            // pnlTop
            // 
            this.pnlTop.BackgroundImageLayout = System.Windows.Forms.ImageLayout.None;
            this.pnlTop.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pnlTop.Controls.Add(this.btnBrowseGamePath);
            this.pnlTop.Controls.Add(this.txtGamePath);
            this.pnlTop.Controls.Add(this.pbxLogo);
            this.pnlTop.Location = new System.Drawing.Point(-1, -1);
            this.pnlTop.Name = "pnlTop";
            this.pnlTop.Size = new System.Drawing.Size(692, 52);
            this.pnlTop.TabIndex = 2;
            // 
            // btnBrowseGamePath
            // 
            this.btnBrowseGamePath.Location = new System.Drawing.Point(592, 16);
            this.btnBrowseGamePath.Name = "btnBrowseGamePath";
            this.btnBrowseGamePath.Size = new System.Drawing.Size(75, 24);
            this.btnBrowseGamePath.TabIndex = 2;
            this.btnBrowseGamePath.Text = "Browse";
            this.btnBrowseGamePath.UseVisualStyleBackColor = true;
            this.btnBrowseGamePath.Click += new System.EventHandler(this.btnBrowseGamePath_Click);
            // 
            // txtGamePath
            // 
            this.txtGamePath.Location = new System.Drawing.Point(487, 17);
            this.txtGamePath.Name = "txtGamePath";
            this.txtGamePath.ReadOnly = true;
            this.txtGamePath.Size = new System.Drawing.Size(100, 22);
            this.txtGamePath.TabIndex = 1;
            this.txtGamePath.Text = "< game path >";
            // 
            // pnlButtons
            // 
            this.pnlButtons.Controls.Add(this.button3);
            this.pnlButtons.Controls.Add(this.button2);
            this.pnlButtons.Controls.Add(this.btnResource);
            this.pnlButtons.Controls.Add(this.btnAndroid);
            this.pnlButtons.Controls.Add(this.button1);
            this.pnlButtons.Controls.Add(this.btnPatternEdit);
            this.pnlButtons.Enabled = false;
            this.pnlButtons.Location = new System.Drawing.Point(-1, 52);
            this.pnlButtons.Name = "pnlButtons";
            this.pnlButtons.Size = new System.Drawing.Size(692, 354);
            this.pnlButtons.TabIndex = 3;
            // 
            // btnAndroid
            // 
            this.btnAndroid.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.btnAndroid.Font = new System.Drawing.Font("Segoe UI", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnAndroid.ForeColor = System.Drawing.Color.White;
            this.btnAndroid.Image = ((System.Drawing.Image)(resources.GetObject("btnAndroid.Image")));
            this.btnAndroid.Location = new System.Drawing.Point(454, 15);
            this.btnAndroid.Name = "btnAndroid";
            this.btnAndroid.Size = new System.Drawing.Size(214, 74);
            this.btnAndroid.TabIndex = 3;
            this.btnAndroid.Text = "CREATE APK";
            this.btnAndroid.UseVisualStyleBackColor = true;
            // 
            // button1
            // 
            this.button1.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("button1.BackgroundImage")));
            this.button1.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.button1.Font = new System.Drawing.Font("Segoe UI", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.button1.ForeColor = System.Drawing.Color.White;
            this.button1.Location = new System.Drawing.Point(234, 15);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(214, 74);
            this.button1.TabIndex = 2;
            this.button1.Text = "EDIT BACKGROUNDS";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // btnResource
            // 
            this.btnResource.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.btnResource.Font = new System.Drawing.Font("Segoe UI", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnResource.ForeColor = System.Drawing.Color.White;
            this.btnResource.Location = new System.Drawing.Point(13, 95);
            this.btnResource.Name = "btnResource";
            this.btnResource.Size = new System.Drawing.Size(214, 74);
            this.btnResource.TabIndex = 4;
            this.btnResource.Text = "EDIT RESOURCES";
            this.btnResource.UseVisualStyleBackColor = true;
            // 
            // button2
            // 
            this.button2.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.button2.Font = new System.Drawing.Font("Segoe UI", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.button2.ForeColor = System.Drawing.Color.White;
            this.button2.Location = new System.Drawing.Point(234, 95);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(214, 74);
            this.button2.TabIndex = 5;
            this.button2.Text = "MODS";
            this.button2.UseVisualStyleBackColor = true;
            // 
            // button3
            // 
            this.button3.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.button3.Font = new System.Drawing.Font("Segoe UI", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.button3.ForeColor = System.Drawing.Color.White;
            this.button3.Location = new System.Drawing.Point(454, 95);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(214, 74);
            this.button3.TabIndex = 6;
            this.button3.Text = "LEVEL DEPOT";
            this.button3.UseVisualStyleBackColor = true;
            // 
            // frmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.ClientSize = new System.Drawing.Size(680, 404);
            this.Controls.Add(this.pnlButtons);
            this.Controls.Add(this.pnlTop);
            this.Font = new System.Drawing.Font("Segoe UI", 8.25F);
            this.Name = "frmMain";
            this.Text = "mainScreen";
            this.Load += new System.EventHandler(this.frmMain_Load);
            ((System.ComponentModel.ISupportInitialize)(this.pbxLogo)).EndInit();
            this.pnlTop.ResumeLayout(false);
            this.pnlTop.PerformLayout();
            this.pnlButtons.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.PictureBox pbxLogo;
        private System.Windows.Forms.Button btnPatternEdit;
        private System.Windows.Forms.Panel pnlTop;
        private System.Windows.Forms.Button btnBrowseGamePath;
        private System.Windows.Forms.TextBox txtGamePath;
        private System.Windows.Forms.Panel pnlButtons;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button btnAndroid;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button btnResource;
    }
}