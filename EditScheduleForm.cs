using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class EditScheduleForm : Form
    {
        private ComboBox cbFaculty = new ComboBox();
        private ComboBox cbSpecialty = new ComboBox();
        private ComboBox cbKurs = new ComboBox();
        private ComboBox cbGroup = new ComboBox();
        private DataGridView dgvSchedule = new DataGridView();
        private Button btnSave = new Button();

        private string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        public EditScheduleForm()
        {
            InitializeComponent();
            SetupUI();
            LoadFaculties();
        }

        private void SetupUI()
        {
            this.Text = "Edit Schedule";
            this.Size = new Size(900, 600);
            this.StartPosition = FormStartPosition.CenterScreen;

            int labelX = 20, comboX = 120, top = 20, gap = 35;

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

            dgvSchedule.Location = new Point(20, top);
            dgvSchedule.Size = new Size(840, 350);
            dgvSchedule.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvSchedule.MultiSelect = false;
            dgvSchedule.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvSchedule.AllowUserToAddRows = false;
            this.Controls.Add(dgvSchedule);
            top += 360;

            btnSave.Text = "Save Changes";
            btnSave.Location = new Point(comboX, top);
            this.Controls.Add(btnSave);

            cbFaculty.SelectedIndexChanged += CbFaculty_SelectedIndexChanged;
            cbSpecialty.SelectedIndexChanged += CbSpecialty_SelectedIndexChanged;
            cbKurs.SelectedIndexChanged += CbKurs_SelectedIndexChanged;
            cbGroup.SelectedIndexChanged += CbGroup_SelectedIndexChanged;
            btnSave.Click += BtnSave_Click;
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
                dgvSchedule.DataSource = null;
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
                dgvSchedule.DataSource = null;
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

                dgvSchedule.DataSource = null;
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
                LoadSchedule(groupId);
        }

        private void LoadSchedule(int groupId)
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();

                string sql = @"
            SELECT 
                p.programid, 
                p.subjectid, 
                s.name AS subject_name, 
                p.lecturerid, 
                l.firstname || ' ' || l.lastname AS lecturer_name, 
                p.type AS type_col,
                p.day,
                p.hour
            FROM programi p
            JOIN predmeti s ON p.subjectid = s.subjectid
            JOIN lecturers l ON p.lecturerid = l.lecturerid
            WHERE p.groupid = :gid
            ORDER BY p.type, s.name";

                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("gid", groupId);
                using var adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                dgvSchedule.DataSource = dt;

                // Remove previously added combo columns if they exist
                foreach (string colName in new string[] { "subject_col", "lecturer_col", "type_col" })
                {
                    if (dgvSchedule.Columns.Contains(colName))
                        dgvSchedule.Columns.Remove(colName);
                }

                dgvSchedule.Columns["programid"].ReadOnly = true;
                dgvSchedule.Columns["day"].ReadOnly = true;
                dgvSchedule.Columns["hour"].ReadOnly = true;

                // Add combo columns
                var subjCol = new DataGridViewComboBoxColumn
                {
                    Name = "subject_col",
                    DataPropertyName = "subjectid",
                    HeaderText = "Subject",
                    DisplayMember = "name",
                    ValueMember = "subjectid",
                    DataSource = GetSubjectsForGroup(groupId)
                };
                dgvSchedule.Columns.Add(subjCol);

                var lectCol = new DataGridViewComboBoxColumn
                {
                    Name = "lecturer_col",
                    DataPropertyName = "lecturerid",
                    HeaderText = "Lecturer",
                    DisplayMember = "fullname",
                    ValueMember = "lecturerid",
                    DataSource = GetAllLecturers()
                };
                dgvSchedule.Columns.Add(lectCol);

                var typeCol = new DataGridViewComboBoxColumn
                {
                    Name = "type_col",
                    DataPropertyName = "type_col",
                    HeaderText = "Type",
                    DataSource = new string[] { "Lecture", "Exercise" }
                };
                dgvSchedule.Columns.Add(typeCol);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading schedule: " + ex.Message);
            }
        }


        private DataTable GetSubjectsForGroup(int groupId)
        {
            DataTable dt = new DataTable();
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = @"
                    SELECT subjectid, name
                    FROM predmeti
                    WHERE specid = (SELECT specid FROM grupi WHERE groupid = :gid)";
                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("gid", groupId);
                using var adapter = new OracleDataAdapter(cmd);
                adapter.Fill(dt);
            }
            catch { }
            return dt;
        }

        private DataTable GetAllLecturers()
        {
            DataTable dt = new DataTable();
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = "SELECT lecturerid, firstname || ' ' || lastname AS fullname FROM lecturers";
                using var cmd = new OracleCommand(sql, conn);
                using var adapter = new OracleDataAdapter(cmd);
                adapter.Fill(dt);
            }
            catch { }
            return dt;
        }

        private void BtnSave_Click(object? sender, EventArgs e)
        {
            if (dgvSchedule.CurrentRow == null) return;

            try
            {
                var row = dgvSchedule.CurrentRow;

                int programId = Convert.ToInt32(row.Cells["programid"].Value);
                int subjectId = Convert.ToInt32(row.Cells["subject_col"].Value);
                int lecturerId = Convert.ToInt32(row.Cells["lecturer_col"].Value);
                string type = row.Cells["type_col"].Value?.ToString() ?? "Exercise";

                using var conn = new OracleConnection(connectionString);
                conn.Open();

                string sql = @"
            UPDATE programi
            SET subjectid = :sid, lecturerid = :lid, type = :typ
            WHERE programid = :pid";

                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add("sid", subjectId);
                cmd.Parameters.Add("lid", lecturerId);
                cmd.Parameters.Add("typ", type);
                cmd.Parameters.Add("pid", programId);

                int rows = cmd.ExecuteNonQuery();
                MessageBox.Show(rows > 0 ? "Schedule updated successfully!" : "No changes saved.");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error saving schedule: " + ex.Message);
            }
        }
    }
}
