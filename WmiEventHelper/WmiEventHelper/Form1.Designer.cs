namespace WmiEventHelper
{
    partial class FormWmiEventHelper
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
            this.ListFilters = new System.Windows.Forms.ListView();
            this.ListConsumers = new System.Windows.Forms.ListView();
            this.label1 = new System.Windows.Forms.Label();
            this.ComboConsumerType = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.BtnRemoveFilter = new System.Windows.Forms.Button();
            this.BtnRemoveConsumer = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.ListBoxBindings = new System.Windows.Forms.ListBox();
            this.ButtonRemoveBinding = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // ListFilters
            // 
            this.ListFilters.Location = new System.Drawing.Point(12, 29);
            this.ListFilters.Name = "ListFilters";
            this.ListFilters.Size = new System.Drawing.Size(253, 227);
            this.ListFilters.TabIndex = 0;
            this.ListFilters.UseCompatibleStateImageBehavior = false;
            this.ListFilters.View = System.Windows.Forms.View.List;
            // 
            // ListConsumers
            // 
            this.ListConsumers.Location = new System.Drawing.Point(274, 71);
            this.ListConsumers.Name = "ListConsumers";
            this.ListConsumers.Size = new System.Drawing.Size(256, 185);
            this.ListConsumers.TabIndex = 3;
            this.ListConsumers.UseCompatibleStateImageBehavior = false;
            this.ListConsumers.View = System.Windows.Forms.View.List;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(271, 55);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(59, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Consumers";
            // 
            // ComboConsumerType
            // 
            this.ComboConsumerType.FormattingEnabled = true;
            this.ComboConsumerType.Items.AddRange(new object[] {
            "ActiveScriptEventConsumer",
            "SMTPEventConsumer",
            "LogFileEventConsumer",
            "NTEventLogEventConsumer",
            "CommandLineEventConsumer"});
            this.ComboConsumerType.Location = new System.Drawing.Point(274, 31);
            this.ComboConsumerType.Name = "ComboConsumerType";
            this.ComboConsumerType.Size = new System.Drawing.Size(256, 21);
            this.ComboConsumerType.TabIndex = 2;
            this.ComboConsumerType.SelectedIndexChanged += new System.EventHandler(this.ComboConsumerType_SelectedIndexChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(271, 13);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(81, 13);
            this.label2.TabIndex = 4;
            this.label2.Text = "Consumer Type";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(9, 9);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(34, 13);
            this.label3.TabIndex = 5;
            this.label3.Text = "Filters";
            // 
            // BtnRemoveFilter
            // 
            this.BtnRemoveFilter.Location = new System.Drawing.Point(66, 263);
            this.BtnRemoveFilter.Name = "BtnRemoveFilter";
            this.BtnRemoveFilter.Size = new System.Drawing.Size(145, 23);
            this.BtnRemoveFilter.TabIndex = 1;
            this.BtnRemoveFilter.Text = "Remove Filter";
            this.BtnRemoveFilter.UseVisualStyleBackColor = true;
            this.BtnRemoveFilter.Click += new System.EventHandler(this.BtnRemoveFilter_Click);
            // 
            // BtnRemoveConsumer
            // 
            this.BtnRemoveConsumer.Location = new System.Drawing.Point(334, 262);
            this.BtnRemoveConsumer.Name = "BtnRemoveConsumer";
            this.BtnRemoveConsumer.Size = new System.Drawing.Size(136, 23);
            this.BtnRemoveConsumer.TabIndex = 4;
            this.BtnRemoveConsumer.Text = "Remove Consumer";
            this.BtnRemoveConsumer.UseVisualStyleBackColor = true;
            this.BtnRemoveConsumer.Click += new System.EventHandler(this.BtnRemoveConsumer_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(533, 13);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(47, 13);
            this.label4.TabIndex = 7;
            this.label4.Text = "Bindings";
            // 
            // ListBoxBindings
            // 
            this.ListBoxBindings.FormattingEnabled = true;
            this.ListBoxBindings.HorizontalScrollbar = true;
            this.ListBoxBindings.Location = new System.Drawing.Point(536, 31);
            this.ListBoxBindings.Name = "ListBoxBindings";
            this.ListBoxBindings.Size = new System.Drawing.Size(250, 225);
            this.ListBoxBindings.TabIndex = 8;
            // 
            // ButtonRemoveBinding
            // 
            this.ButtonRemoveBinding.Location = new System.Drawing.Point(599, 262);
            this.ButtonRemoveBinding.Name = "ButtonRemoveBinding";
            this.ButtonRemoveBinding.Size = new System.Drawing.Size(125, 23);
            this.ButtonRemoveBinding.TabIndex = 9;
            this.ButtonRemoveBinding.Text = "Remove Binding";
            this.ButtonRemoveBinding.UseVisualStyleBackColor = true;
            this.ButtonRemoveBinding.Click += new System.EventHandler(this.ButtonRemoveBinding_Click);
            // 
            // FormWmiEventHelper
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(798, 296);
            this.Controls.Add(this.ButtonRemoveBinding);
            this.Controls.Add(this.ListBoxBindings);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.BtnRemoveConsumer);
            this.Controls.Add(this.BtnRemoveFilter);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.ComboConsumerType);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.ListConsumers);
            this.Controls.Add(this.ListFilters);
            this.Name = "FormWmiEventHelper";
            this.Text = "WMI Event Helper";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ListView ListFilters;
        private System.Windows.Forms.ListView ListConsumers;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox ComboConsumerType;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button BtnRemoveFilter;
        private System.Windows.Forms.Button BtnRemoveConsumer;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ListBox ListBoxBindings;
        private System.Windows.Forms.Button ButtonRemoveBinding;
    }
}

