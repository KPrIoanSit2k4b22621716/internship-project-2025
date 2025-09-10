using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class ChangeStatusForm : Form
    {
        private ComboBox cbFaculty = new ComboBox();
        private ComboBox cbSpecialty = new ComboBox();
        private ComboBox cbGroup = new ComboBox();
        private ComboBox cbStudent = new ComboBox();
        private ComboBox cbStatus = new ComboBox();
        private Button btnSave = new Button();
        private Label lblCurrentStatus = new Label();

        private string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        public ChangeStatusForm()
        {
            InitializeComponent();
            SetupUI();
            LoadFaculties();
        }

        private void SetupUI()
        {
            this.Text = "Change Student Status";
            this.Size = new Size(600, 400);
            this.StartPosition = FormStartPosition.CenterScreen;

            int labelX = 20, comboX = 150, top = 20, gap = 35;

            void AddLabelAndControl(string labelText, Control control)
            {
                Label lbl = new Label
                {
                    Text = labelText,
                    Location = new Point(labelX, top),
                    AutoSize = true
                };
                control.Location = new Point(comboX, top - 3);
                control.Width = 200;
                this.Controls.Add(lbl);
                this.Controls.Add(control);
                top += gap;
            }

            AddLabelAndControl("Faculty:", cbFaculty);
            AddLabelAndControl("Specialty:", cbSpecialty);
            AddLabelAndControl("Group:", cbGroup);
            AddLabelAndControl("Student:", cbStudent);

            lblCurrentStatus.Text = "Current Status: -";
            lblCurrentStatus.Location = new Point(labelX, top);
            lblCurrentStatus.AutoSize = true;
            this.Controls.Add(lblCurrentStatus);
            top += gap;

            AddLabelAndControl("New Status:", cbStatus);
            cbStatus.Items.AddRange(new string[]
            {
                "Active",
                "Graduated",
                "Removed - Tuition Fee",
                "Removed - Family Issues",
                "Removed - Voluntary",
                "Suspended"
            });

            btnSave.Text = "Save";
            btnSave.Location = new Point(comboX, top + 10);
            this.Controls.Add(btnSave);

            cbFaculty.SelectedIndexChanged += CbFaculty_SelectedIndexChanged;
            cbSpecialty.SelectedIndexChanged += CbSpecialty_SelectedIndexChanged;
            cbGroup.SelectedIndexChanged += CbGroup_SelectedIndexChanged;
            cbStudent.SelectedIndexChanged += CbStudent_SelectedIndexChanged;
            btnSave.Click += BtnSave_Click;
        }

        private void LoadFaculties()
        {
            using var conn = new OracleConnection(connectionString);
            conn.Open();
            string sql = "SELECT fakultetid, fullname FROM fakulteti ORDER BY fullname";
            using var cmd = new OracleCommand(sql, conn);
            using var adapter = new OracleDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);

            cbFaculty.DataSource = dt;
            cbFaculty.DisplayMember = "fullname";
            cbFaculty.ValueMember = "fakultetid";
            cbFaculty.SelectedIndex = -1;
        }

        private void CbFaculty_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cbFaculty.SelectedValue == null || cbFaculty.SelectedValue is DataRowView) return;
            if (int.TryParse(cbFaculty.SelectedValue?.ToString(), out int fid))
                LoadSpecialties(fid);
        }

        private void LoadSpecialties(int facultyId)
        {
            using var conn = new OracleConnection(connectionString);
            conn.Open();
            string sql = "SELECT specid, name FROM specialnosti WHERE fakultetid = :fid ORDER BY name";
            using var cmd = new OracleCommand(sql, conn);
            cmd.Parameters.Add("fid", facultyId);
            using var adapter = new OracleDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);

            cbSpecialty.DataSource = dt;
            cbSpecialty.DisplayMember = "name";
            cbSpecialty.ValueMember = "specid";
            cbSpecialty.SelectedIndex = -1;

            cbGroup.DataSource = null;
            cbStudent.DataSource = null;
            lblCurrentStatus.Text = "Current Status: -";
        }

        private void CbSpecialty_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cbSpecialty.SelectedValue == null || cbSpecialty.SelectedValue is DataRowView) return;
            if (int.TryParse(cbSpecialty.SelectedValue?.ToString(), out int sid))
                LoadGroups(sid);
        }

        private void LoadGroups(int specId)
        {
            using var conn = new OracleConnection(connectionString);
            conn.Open();
            string sql = "SELECT groupid, name FROM grupi WHERE specid = :sid ORDER BY name";
            using var cmd = new OracleCommand(sql, conn);
            cmd.Parameters.Add("sid", specId);
            using var adapter = new OracleDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);

            cbGroup.DataSource = dt;
            cbGroup.DisplayMember = "name";
            cbGroup.ValueMember = "groupid";
            cbGroup.SelectedIndex = -1;
            cbStudent.DataSource = null;
            lblCurrentStatus.Text = "Current Status: -";
        }

        private void CbGroup_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cbGroup.SelectedValue == null || cbGroup.SelectedValue is DataRowView) return;
            if (int.TryParse(cbGroup.SelectedValue?.ToString(), out int gid))
                LoadStudents(gid);
        }

        private void LoadStudents(int groupId)
        {
            using var conn = new OracleConnection(connectionString);
            conn.Open();
            string sql = @"SELECT studentid, firstname || ' ' || lastname AS fullname, facnom, status
                           FROM students WHERE groupid = :gid ORDER BY fullname";
            using var cmd = new OracleCommand(sql, conn);
            cmd.Parameters.Add("gid", groupId);
            using var adapter = new OracleDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);

            cbStudent.DataSource = dt;
            cbStudent.DisplayMember = "fullname";
            cbStudent.ValueMember = "studentid";
            cbStudent.SelectedIndex = -1;
            lblCurrentStatus.Text = "Current Status: -";
        }

        private void CbStudent_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cbStudent.SelectedItem is DataRowView drv)
            {
                string? currentStatus = drv["status"]?.ToString();
                lblCurrentStatus.Text = "Current Status: " + (currentStatus ?? "-");
            }
            else
            {
                lblCurrentStatus.Text = "Current Status: -";
            }
        }

        private void BtnSave_Click(object? sender, EventArgs e)
        {
            if (cbStudent.SelectedValue == null || cbStatus.SelectedItem == null)
            {
                MessageBox.Show("Please select a student and a new status.");
                return;
            }

            if (!int.TryParse(cbStudent.SelectedValue?.ToString(), out int studentId))
            {
                MessageBox.Show("Invalid student selection.");
                return;
            }

            string newStatus = cbStatus.SelectedItem?.ToString() ?? "Active";

            using var conn = new OracleConnection(connectionString);
            conn.Open();
            string sql = "UPDATE students SET status = :st WHERE studentid = :sid";
            using var cmd = new OracleCommand(sql, conn);
            cmd.Parameters.Add("st", newStatus);
            cmd.Parameters.Add("sid", studentId);

            int rows = cmd.ExecuteNonQuery();
            if (rows > 0)
            {
                MessageBox.Show("Status updated successfully!");
                lblCurrentStatus.Text = "Current Status: " + newStatus;
            }
            else
            {
                MessageBox.Show("Failed to update status.");
            }
        }
    }
}
