using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class MoveStudentForm : Form
    {
        private string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        private ComboBox cmbFacultyCurrent = new ComboBox();
        private ComboBox cmbSpecialtyCurrent = new ComboBox();
        private ComboBox cmbKursCurrent = new ComboBox();
        private ComboBox cmbGroupCurrent = new ComboBox();
        private ComboBox cmbStudent = new ComboBox();

        private ComboBox cmbFacultyNew = new ComboBox();
        private ComboBox cmbSpecialtyNew = new ComboBox();
        private ComboBox cmbKursNew = new ComboBox();
        private ComboBox cmbGroupNew = new ComboBox();

        private Button btnMoveStudent = new Button();

        public MoveStudentForm()
        {
            InitializeComponent();
            SetupUI();
            LoadCurrentFaculties();
            LoadNewFaculties();

            // Attach cascading events
            cmbFacultyCurrent.SelectedIndexChanged += CmbFacultyCurrent_SelectedIndexChanged;
            cmbSpecialtyCurrent.SelectedIndexChanged += CmbSpecialtyCurrent_SelectedIndexChanged;
            cmbKursCurrent.SelectedIndexChanged += CmbKursCurrent_SelectedIndexChanged;
            cmbGroupCurrent.SelectedIndexChanged += CmbGroupCurrent_SelectedIndexChanged;

            cmbFacultyNew.SelectedIndexChanged += CmbFacultyNew_SelectedIndexChanged;
            cmbSpecialtyNew.SelectedIndexChanged += CmbSpecialtyNew_SelectedIndexChanged;
            cmbKursNew.SelectedIndexChanged += CmbKursNew_SelectedIndexChanged;

            btnMoveStudent.Click += BtnMoveStudent_Click;
        }

        private void SetupUI()
        {
            this.Text = "Move Student";
            this.Size = new Size(700, 500);
            this.StartPosition = FormStartPosition.CenterScreen;

            int labelX = 30, controlX = 180, top = 30, gap = 35;

            void AddLabelAndControl(string labelText, Control control)
            {
                Label lbl = new Label
                {
                    Text = labelText,
                    Location = new Point(labelX, top),
                    AutoSize = true
                };
                control.Location = new Point(controlX, top - 3);
                control.Width = 200;
                this.Controls.Add(lbl);
                this.Controls.Add(control);
                top += gap;
            }

            // Current location cascading
            AddLabelAndControl("Faculty (Current):", cmbFacultyCurrent);
            AddLabelAndControl("Specialty (Current):", cmbSpecialtyCurrent);
            AddLabelAndControl("Kurs (Current):", cmbKursCurrent);
            AddLabelAndControl("Group (Current):", cmbGroupCurrent);
            AddLabelAndControl("Student:", cmbStudent);

            top += 20; // spacing

            // New location cascading
            AddLabelAndControl("Faculty (New):", cmbFacultyNew);
            AddLabelAndControl("Specialty (New):", cmbSpecialtyNew);
            AddLabelAndControl("Kurs (New):", cmbKursNew);
            AddLabelAndControl("Group (New):", cmbGroupNew);

            // Move Button
            btnMoveStudent.Text = "Move Student";
            btnMoveStudent.Location = new Point(controlX, top);
            this.Controls.Add(btnMoveStudent);
        }

        // Utility to safely get value from ComboBox
        private int GetComboBoxValue(ComboBox comboBox, string valueMember)
        {
            if (comboBox.SelectedValue == null) return -1;
            if (comboBox.SelectedValue is DataRowView drv)
                return Convert.ToInt32(drv[valueMember]);
            return Convert.ToInt32(comboBox.SelectedValue);
        }

        #region Load Current Dropdowns
        private void LoadCurrentFaculties()
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

                cmbFacultyCurrent.DataSource = dt;
                cmbFacultyCurrent.DisplayMember = "fullname";
                cmbFacultyCurrent.ValueMember = "fakultetid";
                cmbFacultyCurrent.SelectedIndex = -1;

                cmbSpecialtyCurrent.DataSource = null;
                cmbKursCurrent.DataSource = null;
                cmbGroupCurrent.DataSource = null;
                cmbStudent.DataSource = null;
            }
            catch (Exception ex) { MessageBox.Show("Error loading faculties: " + ex.Message); }
        }

        private void CmbFacultyCurrent_SelectedIndexChanged(object? sender, EventArgs e)
        {
            int facultyId = GetComboBoxValue(cmbFacultyCurrent, "fakultetid");
            LoadCurrentSpecialties(facultyId);
        }

        private void LoadCurrentSpecialties(int facultyId)
        {
            if (facultyId == -1) return;
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

                cmbSpecialtyCurrent.DataSource = dt;
                cmbSpecialtyCurrent.DisplayMember = "name";
                cmbSpecialtyCurrent.ValueMember = "specid";
                cmbSpecialtyCurrent.SelectedIndex = -1;

                cmbKursCurrent.DataSource = null;
                cmbGroupCurrent.DataSource = null;
                cmbStudent.DataSource = null;
            }
            catch (Exception ex) { MessageBox.Show("Error loading specialties: " + ex.Message); }
        }

        private void CmbSpecialtyCurrent_SelectedIndexChanged(object? sender, EventArgs e)
        {
            int specId = GetComboBoxValue(cmbSpecialtyCurrent, "specid");
            LoadCurrentKurs(specId);
        }

        private void LoadCurrentKurs(int specId)
        {
            if (specId == -1) return;
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

                cmbKursCurrent.DataSource = dt;
                cmbKursCurrent.DisplayMember = "KURS";
                cmbKursCurrent.ValueMember = "KURS";
                cmbKursCurrent.SelectedIndex = -1;

                cmbGroupCurrent.DataSource = null;
                cmbStudent.DataSource = null;
            }
            catch (Exception ex) { MessageBox.Show("Error loading kurs: " + ex.Message); }
        }

        private void CmbKursCurrent_SelectedIndexChanged(object? sender, EventArgs e)
        {
            int specId = GetComboBoxValue(cmbSpecialtyCurrent, "specid");
            int kurs = GetComboBoxValue(cmbKursCurrent, "KURS");
            LoadCurrentGroups(specId, kurs);
        }

        private void LoadCurrentGroups(int specId, int kurs)
        {
            if (specId == -1 || kurs == -1) return;
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = "SELECT groupid, name FROM grupi WHERE specid = :sid AND kurs = :kurs ORDER BY name";
                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("sid", specId);
                cmd.Parameters.Add("kurs", kurs);
                using var adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                cmbGroupCurrent.DataSource = dt;
                cmbGroupCurrent.DisplayMember = "name";
                cmbGroupCurrent.ValueMember = "groupid";
                cmbGroupCurrent.SelectedIndex = -1;

                cmbStudent.DataSource = null;
            }
            catch (Exception ex) { MessageBox.Show("Error loading groups: " + ex.Message); }
        }

        private void CmbGroupCurrent_SelectedIndexChanged(object? sender, EventArgs e)
        {
            int groupId = GetComboBoxValue(cmbGroupCurrent, "groupid");
            LoadStudents(groupId);
        }

        private void LoadStudents(int groupId)
        {
            if (groupId == -1) return;
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = "SELECT studentid, firstname || ' ' || lastname AS fullname FROM students WHERE groupid = :gid ORDER BY lastname, firstname";
                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("gid", groupId);
                using var adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                cmbStudent.DataSource = dt;
                cmbStudent.DisplayMember = "fullname";
                cmbStudent.ValueMember = "studentid";
                cmbStudent.SelectedIndex = -1;
            }
            catch (Exception ex) { MessageBox.Show("Error loading students: " + ex.Message); }
        }
        #endregion

        #region Load New Destination Dropdowns
        private void LoadNewFaculties()
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

                cmbFacultyNew.DataSource = dt;
                cmbFacultyNew.DisplayMember = "fullname";
                cmbFacultyNew.ValueMember = "fakultetid";
                cmbFacultyNew.SelectedIndex = -1;

                cmbSpecialtyNew.DataSource = null;
                cmbKursNew.DataSource = null;
                cmbGroupNew.DataSource = null;
            }
            catch (Exception ex) { MessageBox.Show("Error loading faculties: " + ex.Message); }
        }

        private void CmbFacultyNew_SelectedIndexChanged(object? sender, EventArgs e)
        {
            int facultyId = GetComboBoxValue(cmbFacultyNew, "fakultetid");
            LoadNewSpecialties(facultyId);
        }

        private void LoadNewSpecialties(int facultyId)
        {
            if (facultyId == -1) return;
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

                cmbSpecialtyNew.DataSource = dt;
                cmbSpecialtyNew.DisplayMember = "name";
                cmbSpecialtyNew.ValueMember = "specid";
                cmbSpecialtyNew.SelectedIndex = -1;

                cmbKursNew.DataSource = null;
                cmbGroupNew.DataSource = null;
            }
            catch (Exception ex) { MessageBox.Show("Error loading specialties: " + ex.Message); }
        }

        private void CmbSpecialtyNew_SelectedIndexChanged(object? sender, EventArgs e)
        {
            int specId = GetComboBoxValue(cmbSpecialtyNew, "specid");
            LoadNewKurs(specId);
        }

        private void LoadNewKurs(int specId)
        {
            if (specId == -1) return;
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

                cmbKursNew.DataSource = dt;
                cmbKursNew.DisplayMember = "KURS";
                cmbKursNew.ValueMember = "KURS";
                cmbKursNew.SelectedIndex = -1;

                cmbGroupNew.DataSource = null;
            }
            catch (Exception ex) { MessageBox.Show("Error loading kurs: " + ex.Message); }
        }

        private void CmbKursNew_SelectedIndexChanged(object? sender, EventArgs e)
        {
            int specId = GetComboBoxValue(cmbSpecialtyNew, "specid");
            int kurs = GetComboBoxValue(cmbKursNew, "KURS");
            LoadNewGroups(specId, kurs);
        }

        private void LoadNewGroups(int specId, int kurs)
        {
            if (specId == -1 || kurs == -1) return;
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = "SELECT groupid, name FROM grupi WHERE specid = :sid AND kurs = :kurs ORDER BY name";
                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("sid", specId);
                cmd.Parameters.Add("kurs", kurs);
                using var adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                cmbGroupNew.DataSource = dt;
                cmbGroupNew.DisplayMember = "name";
                cmbGroupNew.ValueMember = "groupid";
                cmbGroupNew.SelectedIndex = -1;
            }
            catch (Exception ex) { MessageBox.Show("Error loading groups: " + ex.Message); }
        }
        #endregion

        private void BtnMoveStudent_Click(object? sender, EventArgs e)
        {
            if (cmbStudent.SelectedIndex == -1 ||
                cmbFacultyNew.SelectedIndex == -1 ||
                cmbSpecialtyNew.SelectedIndex == -1 ||
                cmbKursNew.SelectedIndex == -1 ||
                cmbGroupNew.SelectedIndex == -1)
            {
                MessageBox.Show("Please select all required fields.");
                return;
            }

            try
            {
                int studentId = GetComboBoxValue(cmbStudent, "studentid");
                int newFacultyId = GetComboBoxValue(cmbFacultyNew, "fakultetid");
                int newSpecId = GetComboBoxValue(cmbSpecialtyNew, "specid");
                int newKurs = GetComboBoxValue(cmbKursNew, "KURS");
                int newGroupId = GetComboBoxValue(cmbGroupNew, "groupid");

                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = @"
                    UPDATE students
                    SET fakultetid = :fid,
                        specid = :sid,
                        kurs = :kurs,
                        groupid = :gid
                    WHERE studentid = :stid";
                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("fid", newFacultyId);
                cmd.Parameters.Add("sid", newSpecId);
                cmd.Parameters.Add("kurs", newKurs);
                cmd.Parameters.Add("gid", newGroupId);
                cmd.Parameters.Add("stid", studentId);

                int rowsUpdated = cmd.ExecuteNonQuery();
                if (rowsUpdated > 0) MessageBox.Show("Student moved successfully!");
                else MessageBox.Show("Failed to move student.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error moving student: " + ex.Message);
            }
        }
    }
}
