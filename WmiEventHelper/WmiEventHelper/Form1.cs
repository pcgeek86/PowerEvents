/*
 * Author: Trevor Sullivan
 * 
 * Date: 12/14/10
 * 
 * Purpose: This program helps to delete WMI event consumers and filters
 * 
 */
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Diagnostics;
using System.Text;
using System.Windows.Forms;
using System.Management;

namespace WmiEventHelper
{
    public partial class FormWmiEventHelper : Form
    {
        public FormWmiEventHelper()
        {
            InitializeComponent();

            PopulateFilters();
            PopulateBindings();
        }

        private void PopulateConsumers(string ConsumerType)
        {
            // Clear all items from consumer ListBox
            ListConsumers.Items.Clear();

            try
            {
                ManagementClass consumerclass = new ManagementClass(@"root\subscription:" + ConsumerType);
                ManagementObjectCollection consumerlist = consumerclass.GetInstances();
                ListViewGroup ligroup = new ListViewGroup("Consumers", HorizontalAlignment.Left);

                foreach (ManagementObject consumer in consumerlist)
                {
                    ListViewItem li = new ListViewItem(consumer.Properties["Name"].Value.ToString(), ligroup);
                    Debug.WriteLine("Consumer name: " + consumer.Properties["Name"].Value.ToString());
                    ListConsumers.Items.Add(li);
                }
            }
            catch
            {
                Debug.WriteLine("Error occurred enumerating consumers of type: " + ConsumerType);
            }
        }
        
        private void PopulateFilters()
        {
            ListFilters.Items.Clear();

            ManagementClass filters = new ManagementClass(@"root\subscription:__EventFilter");
            ManagementObjectCollection filterlist = filters.GetInstances();
            ListViewGroup ligroup = new ListViewGroup("Filters",HorizontalAlignment.Left);

            foreach (ManagementObject filter in filterlist)
            {
                ListViewItem li = new ListViewItem(filter.Properties["Name"].Value.ToString());
                Debug.WriteLine("Filter name: " + filter.Properties["Name"].Value.ToString());
                ListFilters.Items.Add(li);
            }

        }

        private void PopulateBindings()
        {
            ListBoxBindings.Items.Clear();

            ManagementClass bindingclass = new ManagementClass(@"root\subscription:__FilterToConsumerBinding");
            ManagementObjectCollection bindinglist = bindingclass.GetInstances();

            foreach (ManagementObject binding in bindinglist)
            {
                ListBoxBindings.Items.Add(binding.Path.ToString());
                Debug.WriteLine("Binding path is: " + binding.Path.ToString());
            }
        }

        private bool RemoveFilter(string name)
        {
            try
            {
                ManagementObject filter = new ManagementObject(@"root\subscription:__EventFilter.Name='" + name + "'");
                filter.Delete();
                Debug.WriteLine("Successfully deleted WMI event filter: " + name);
                return true;
            }
            catch
            {
                Debug.WriteLine("Error occurred deleting filter with name: " + name);
            }
            return false;
        }

        private bool RemoveConsumer(string name, string ConsumerClass)
        {
            try
            {
                ManagementObject consumer = new ManagementObject(@"root\subscription:" + ConsumerClass + ".Name='" + name + "'");
                consumer.Delete();
                Debug.WriteLine("Successfully deleted WMI event consumer type (" + ConsumerClass + ") named: " + name);
                return true;
            }
            catch
            {
                Debug.WriteLine("Error occurred deleting consumer type (" + ConsumerClass + ") named: " + name);
            }
            return false;
        }

        private bool RemoveBinding(string WmiPath)
        {
            try
            {
                ManagementObject binding = new ManagementObject(WmiPath);
                binding.Delete();
                Debug.WriteLine("Successfully deleted WMI event binding: " + WmiPath);
                return true;
            }
            catch
            {
                Debug.WriteLine("Error occurred deleting WMI event binding: " + WmiPath);
            }
            return false;
        }

        private void BtnRemoveFilter_Click(object sender, EventArgs e)
        {
            if (RemoveFilter(ListFilters.SelectedItems[0].Text))
            {
                ListFilters.Items.Remove(ListFilters.SelectedItems[0]);
            }
        }

        private void ComboConsumerType_SelectedIndexChanged(object sender, EventArgs e)
        {
            ComboBox senderComboBox = (ComboBox)sender;

            PopulateConsumers(senderComboBox.SelectedItem.ToString());
        }

        private void BtnRemoveConsumer_Click(object sender, EventArgs e)
        {
            // Get the selected WMI event consumer from the ListView
            ListViewItem SelectedConsumer = ListConsumers.SelectedItems[0];
            // Get the index of the selected consumer
            Int32 SelectedConsumerIndex = SelectedConsumer.Index;

            // Remove the consumer with the specified name and consumer type
            if (RemoveConsumer(SelectedConsumer.Text , ComboConsumerType.SelectedItem.ToString()))
            {
                ListConsumers.Items.Remove(SelectedConsumer);
                MessageBox.Show(SelectedConsumerIndex.ToString()); // debugging only
                
                // Select the item that took the place of the previously selected item
                if (ListConsumers.Items.Count -1 >= SelectedConsumerIndex) { ListConsumers.Items[SelectedConsumerIndex].Selected = true; }
                else if (ListConsumers.Items.Count > 1) { ListConsumers.Items[SelectedConsumerIndex - 1].Selected = true; }
                else if (ListConsumers.Items.Count == 1) { ListConsumers.Items[0].Selected = true; }
                
                // Set focus to the ListConsumers object
                ListConsumers.Select();
            }
        }

        private void ButtonRemoveBinding_Click(object sender, EventArgs e)
        {
            if (RemoveBinding(ListBoxBindings.SelectedItem.ToString()))
            {
                ListBoxBindings.Items.Remove(ListBoxBindings.SelectedItem.ToString());
            }
        }
    }
}
