using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class ViewStudentInfoForm : Form
    {
        private ComboBox cbFaculty = new ComboBox();
        private ComboBox cbSpecialty = new ComboBox();
        private ComboBox cbKurs = new ComboBox();
        private ComboBox cbGroup = new ComboBox();
        private ComboBox cbStudent = new ComboBox();

        private TextBox tbFullName = new TextBox();
        private TextBox tbFacnom = new TextBox();
        private TextBox tbFaculty = new TextBox();
        private TextBox tbSpecialty = new TextBox();
        private TextBox tbGroup = new TextBox();
        private TextBox tbKurs = new TextBox();
        private TextBox tbEducationType = new TextBox();

        private string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        public ViewStudentInfoForm()
        {
            InitializeComponent();
            SetupUI();
            LoadFaculties();
        }

        private void SetupUI()
        {
            this.Text = "View Student Info";
            this.Size = new Size(700, 500);
            this.StartPosition = FormStartPosition.CenterScreen;

            int labelX = 20, comboX = 150, top = 20, gap = 35;

            void AddLabelAndControl(string labelText, Control control, bool readOnly = false)
            {
                Label lbl = new Label
                {
                    Text = labelText,
                    Location = new Point(labelX, top),
                    AutoSize = true
                };
                control.Location = new Point(comboX, top - 3);
                control.Width = 200;
                if (control is TextBox tb) tb.ReadOnly = readOnly;
                this.Controls.Add(lbl);
                this.Controls.Add(control);
                top += gap;
            }

            // ComboBoxes for cascading selection
            AddLabelAndControl("Faculty:", cbFaculty);
            AddLabelAndControl("Specialty:", cbSpecialty);
            AddLabelAndControl("Kurs:", cbKurs);
            AddLabelAndControl("Group:", cbGroup);
            AddLabelAndControl("Student:", cbStudent);

            // TextBoxes for read-only student info
            AddLabelAndControl("Full Name:", tbFullName, true);
            AddLabelAndControl("Facnom:", tbFacnom, true);
            AddLabelAndControl("Faculty:", tbFaculty, true);
            AddLabelAndControl("Specialty:", tbSpecialty, true);
            AddLabelAndControl("Group:", tbGroup, true);
            AddLabelAndControl("Kurs:", tbKurs, true);
            AddLabelAndControl("Education Type:", tbEducationType, true);

            // Event handlers
            cbFaculty.SelectedIndexChanged += CbFaculty_SelectedIndexChanged;
            cbSpecialty.SelectedIndexChanged += CbSpecialty_SelectedIndexChanged;
            cbKurs.SelectedIndexChanged += CbKurs_SelectedIndexChanged;
            cbGroup.SelectedIndexChanged += CbGroup_SelectedIndexChanged;
            cbStudent.SelectedIndexChanged += CbStudent_SelectedIndexChanged;
        }

        private void LoadFaculties()
        {
            try
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

                cbSpecialty.DataSource = null;
                cbKurs.DataSource = null;
                cbGroup.DataSource = null;
                cbStudent.DataSource = null;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading faculties: " + ex.Message);
            }
        }

        private void CbFaculty_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cbFaculty.SelectedValue == null || cbFaculty.SelectedValue is DataRowView) return;
            if (int.TryParse(cbFaculty.SelectedValue.ToString(), out int facultyId))
                LoadSpecialties(facultyId);
        }

        private void LoadSpecialties(int facultyId)
        {
            try
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
                cbStudent.DataSource = null;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading specialties: " + ex.Message);
            }
        }

        private void CbSpecialty_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cbSpecialty.SelectedValue == null || cbSpecialty.SelectedValue is DataRowView) return;
            if (int.TryParse(cbSpecialty.SelectedValue.ToString(), out int specId))
                LoadKurs(specId);
        }

        private void LoadKurs(int specId)
        {
            try
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
                cbKurs.DisplayMember = "KURS";
                cbKurs.ValueMember = "KURS";
                cbKurs.SelectedIndex = -1;

                cbGroup.DataSource = null;
                cbStudent.DataSource = null;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading kurs: " + ex.Message);
            }
        }

        private void CbKurs_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cbKurs.SelectedValue == null || cbKurs.SelectedValue is DataRowView) return;

            if (int.TryParse(cbKurs.SelectedValue.ToString(), out int kurs) &&
                cbSpecialty.SelectedValue != null && int.TryParse(cbSpecialty.SelectedValue.ToString(), out int specId))
                LoadGroups(specId, kurs);
        }

        private void LoadGroups(int specId, int kurs)
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = "SELECT groupid, name FROM grupi WHERE specid = :sid AND kurs = :k ORDER BY name";
                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("sid", specId);
                cmd.Parameters.Add("k", kurs);
                using var adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                cbGroup.DataSource = dt;
                cbGroup.DisplayMember = "name";
                cbGroup.ValueMember = "groupid";
                cbGroup.SelectedIndex = -1;

                cbStudent.DataSource = null;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading groups: " + ex.Message);
            }
        }

        private void CbGroup_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cbGroup.SelectedValue == null || cbGroup.SelectedValue is DataRowView) return;
            if (int.TryParse(cbGroup.SelectedValue.ToString(), out int groupId))
                LoadStudents(groupId);
        }

        private void LoadStudents(int groupId)
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = "SELECT studentid, firstname || ' ' || lastname AS fullname FROM students WHERE groupid = :gid ORDER BY fullname";
                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("gid", groupId);
                using var adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                cbStudent.DataSource = dt;
                cbStudent.DisplayMember = "fullname";
                cbStudent.ValueMember = "studentid";
                cbStudent.SelectedIndex = -1;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading students: " + ex.Message);
            }
        }

        private void CbStudent_SelectedIndexChanged(object? sender, EventArgs e)
        {
            if (cbStudent.SelectedValue == null || cbStudent.SelectedValue is DataRowView) return;
            if (int.TryParse(cbStudent.SelectedValue.ToString(), out int studentId))
                LoadStudentInfo(studentId);
        }

        private void LoadStudentInfo(int studentId)
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = @"
                    SELECT s.firstname || ' ' || s.lastname AS fullname,
                           s.facnom,
                           f.fullname AS faculty,
                           sp.name AS specialty,
                           g.name AS group_name,
                           g.kurs,
                           et.education_type_name
                    FROM students s
                    JOIN fakulteti f ON s.fakultetid = f.fakultetid
                    JOIN specialnosti sp ON s.specid = sp.specid
                    JOIN grupi g ON s.groupid = g.groupid
                    LEFT JOIN education_types et ON s.education_type_id = et.education_type_id
                    WHERE s.studentid = :sid";

                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("sid", studentId);
                using var reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    tbFullName.Text = reader["fullname"].ToString();
                    tbFacnom.Text = reader["facnom"].ToString();
                    tbFaculty.Text = reader["faculty"].ToString();
                    tbSpecialty.Text = reader["specialty"].ToString();
                    tbGroup.Text = reader["group_name"].ToString();
                    tbKurs.Text = reader["kurs"].ToString();
                    tbEducationType.Text = reader["education_type_name"].ToString();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading student info: " + ex.Message);
            }
        }
    }
}
