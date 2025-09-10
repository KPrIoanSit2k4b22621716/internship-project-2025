using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class ViewStudentsByGroups : Form
    {
        private ComboBox cbFaculty = new ComboBox();
        private ComboBox cbSpecialty = new ComboBox();
        private ComboBox cbKurs = new ComboBox();
        private ComboBox cbGroup = new ComboBox();
        private DataGridView dgvStudents = new DataGridView();

        private string connectionString =
            "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        public ViewStudentsByGroups()
        {
            InitializeComponent();
            SetupUI();
            LoadFaculties();
        }

        private void SetupUI()
        {
            this.Text = "View Students by Group";
            this.Size = new Size(900, 600);
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
            AddLabelAndControl("Kurs:", cbKurs);
            AddLabelAndControl("Group:", cbGroup);

            dgvStudents.Location = new Point(20, top);
            dgvStudents.Size = new Size(840, 400);
            dgvStudents.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvStudents.MultiSelect = false;
            dgvStudents.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvStudents.ReadOnly = true;
            this.Controls.Add(dgvStudents);

            cbFaculty.SelectedIndexChanged += CbFaculty_SelectedIndexChanged;
            cbSpecialty.SelectedIndexChanged += CbSpecialty_SelectedIndexChanged;
            cbKurs.SelectedIndexChanged += CbKurs_SelectedIndexChanged;
            cbGroup.SelectedIndexChanged += CbGroup_SelectedIndexChanged;
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
            if (int.TryParse(cbFaculty.SelectedValue.ToString(), out int fid))
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

            cbKurs.DataSource = null;
            cbGroup.DataSource = null;
            dgvStudents.DataSource = null;
        }

        private void CbSpecialty_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cbSpecialty.SelectedValue == null || cbSpecialty.SelectedValue is DataRowView) return;
            if (int.TryParse(cbSpecialty.SelectedValue.ToString(), out int specId))
                LoadKurs(specId);
        }

        private void LoadKurs(int specId)
        {
            using var conn = new OracleConnection(connectionString);
            conn.Open();
            string sql = "SELECT DISTINCT kurs FROM grupi WHERE specid = :sid ORDER BY kurs";
            using var cmd = new OracleCommand(sql, conn);
            cmd.Parameters.Add("sid", specId);
            using var adapter = new OracleDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);

            cbKurs.DataSource = dt;
            cbKurs.DisplayMember = "kurs";
            cbKurs.ValueMember = "kurs";
            cbKurs.SelectedIndex = -1;

            cbGroup.DataSource = null;
            dgvStudents.DataSource = null;
        }

        private void CbKurs_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cbKurs.SelectedValue == null || cbKurs.SelectedValue is DataRowView) return;
            if (int.TryParse(cbKurs.SelectedValue.ToString(), out int kurs))
                LoadGroups(kurs);
        }

        private void LoadGroups(int kurs)
        {
            if (cbSpecialty.SelectedValue == null) return;
            int specId = Convert.ToInt32(cbSpecialty.SelectedValue);

            using var conn = new OracleConnection(connectionString);
            conn.Open();
            string sql = "SELECT groupid, name FROM grupi WHERE specid = :specid AND kurs = :kurs ORDER BY name";
            using var cmd = new OracleCommand(sql, conn);
            cmd.Parameters.Add("specid", specId);
            cmd.Parameters.Add("kurs", kurs);
            using var adapter = new OracleDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);

            cbGroup.DataSource = dt;
            cbGroup.DisplayMember = "name";
            cbGroup.ValueMember = "groupid";
            cbGroup.SelectedIndex = -1;

            dgvStudents.DataSource = null;
        }

        private void CbGroup_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cbGroup.SelectedValue == null || cbGroup.SelectedValue is DataRowView) return;
            if (int.TryParse(cbGroup.SelectedValue.ToString(), out int groupId))
                LoadStudents(groupId);
        }

        private void LoadStudents(int groupId)
        {
            using var conn = new OracleConnection(connectionString);
            conn.Open();
            string sql = @"
                SELECT studentid, firstname || ' ' || lastname AS fullname, facnom, status
                FROM students
                WHERE groupid = :groupId
                ORDER BY fullname";
            using var cmd = new OracleCommand(sql, conn);
            cmd.Parameters.Add("groupId", groupId);
            using var adapter = new OracleDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);

            dgvStudents.DataSource = dt;
        }
    }
}
