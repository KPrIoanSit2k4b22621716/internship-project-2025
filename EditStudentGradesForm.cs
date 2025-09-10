using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class EditStudentGradesForm : Form
    {
        // Role management
        private readonly string userRole; // "Student" or "Admin"
        private readonly int? currentStudentId; // Only for Student role

        // UI Controls
        private ComboBox cbFaculty = new ComboBox();
        private ComboBox cbSpecialty = new ComboBox();
        private ComboBox cbKurs = new ComboBox();
        private ComboBox cbGroup = new ComboBox();
        private ComboBox cbStudent = new ComboBox();
        private DataGridView dgvGrades = new DataGridView();
        private Button btnSave = new Button();
        private DateTimePicker dtpCalendar = new DateTimePicker();

        private string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        public EditStudentGradesForm(string role, int? studentId = null)
        {
            userRole = role;
            currentStudentId = studentId;

            InitializeComponent();
            SetupUI();
            LoadFaculties();

            if (userRole == "Student" && currentStudentId.HasValue)
            {
                DisableComboBoxes();
                LoadGrades(currentStudentId.Value);
            }
        }

        private void SetupUI()
        {
            this.Text = "Edit Student Grades";
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
            AddLabelAndControl("Student:", cbStudent);

            // DataGridView
            dgvGrades.Location = new Point(20, top);
            dgvGrades.Size = new Size(840, 350);
            dgvGrades.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvGrades.MultiSelect = false;
            dgvGrades.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvGrades.AllowUserToAddRows = false;
            this.Controls.Add(dgvGrades);
            top += 360;

            // Save Button
            btnSave.Text = "Save Changes";
            btnSave.Location = new Point(this.Width - 150, 20);
            btnSave.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            btnSave.Visible = userRole != "Student";
            this.Controls.Add(btnSave);

            // DateTimePicker
            dtpCalendar.Format = DateTimePickerFormat.Short;
            dtpCalendar.Location = new Point(btnSave.Left - 150, btnSave.Bottom + 10);
            dtpCalendar.Width = 120;
            this.Controls.Add(dtpCalendar);

            // Event Handlers
            cbFaculty.SelectedIndexChanged += CbFaculty_SelectedIndexChanged;
            cbSpecialty.SelectedIndexChanged += CbSpecialty_SelectedIndexChanged;
            cbKurs.SelectedIndexChanged += CbKurs_SelectedIndexChanged;
            cbGroup.SelectedIndexChanged += CbGroup_SelectedIndexChanged;
            cbStudent.SelectedIndexChanged += CbStudent_SelectedIndexChanged;

            btnSave.Click += BtnSave_Click;

            dgvGrades.SelectionChanged += DgvGrades_SelectionChanged;
            dtpCalendar.ValueChanged += DtpCalendar_ValueChanged;
        }

        private void DisableComboBoxes()
        {
            cbFaculty.Enabled = false;
            cbSpecialty.Enabled = false;
            cbKurs.Enabled = false;
            cbGroup.Enabled = false;
            cbStudent.Enabled = false;
        }

        #region Cascading ComboBox Loaders

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
                cbStudent.DataSource = null;
                dgvGrades.DataSource = null;
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
                dgvGrades.DataSource = null;
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
                dgvGrades.DataSource = null;
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

                dgvGrades.DataSource = null;
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
                LoadGrades(studentId);
        }

        #endregion

        #region LoadGrades / Save

        private void LoadGrades(int studentId)
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();

                string sql = @"
                    SELECT o.gradeid AS GRADEID,
                           o.subjectid AS SUBJECTID,
                           p.name AS SUBJECT_NAME,
                           o.grade AS GRADE,
                           o.grade_date AS GRADE_DATE,
                           o.lecturerid AS LECTURERID
                    FROM ocenki o
                    JOIN predmeti p ON o.subjectid = p.subjectid
                    WHERE o.studentid = :sid
                    ORDER BY o.gradeid";

                using var cmd = new OracleCommand(sql, conn);
                cmd.Parameters.Add(new OracleParameter("sid", OracleDbType.Int32) { Value = studentId });

                using var adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                if (dt.Rows.Count == 0)
                {
                    MessageBox.Show("No grades found for this student.");
                    dgvGrades.DataSource = null;
                    return;
                }

                dgvGrades.Columns.Clear();
                dgvGrades.DataSource = dt;

                dgvGrades.Columns["GRADEID"].ReadOnly = true;
                dgvGrades.Columns["SUBJECTID"].Visible = false;

                // Lecturer combo
                var lecturerCol = new DataGridViewComboBoxColumn
                {
                    Name = "lecturer_col",
                    HeaderText = "Lecturer",
                    DataPropertyName = "LECTURERID",
                    DisplayMember = "FULLNAME",
                    ValueMember = "LECTURERID",
                    DataSource = GetAllLecturers()
                };
                dgvGrades.Columns.Add(lecturerCol);

                dgvGrades.Columns["GRADE"].ReadOnly = userRole == "Student";
                dgvGrades.Columns["GRADE_DATE"].ReadOnly = true;
                dgvGrades.Columns["SUBJECT_NAME"].ReadOnly = true;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading grades: " + ex.Message);
            }
        }

        private DataTable GetAllLecturers()
        {
            DataTable dt = new DataTable();
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();
                string sql = "SELECT lecturerid AS LECTURERID, firstname || ' ' || lastname AS FULLNAME FROM lecturers";
                using var cmd = new OracleCommand(sql, conn);
                using var adapter = new OracleDataAdapter(cmd);
                adapter.Fill(dt);
            }
            catch { }
            return dt;
        }

        private void DgvGrades_SelectionChanged(object? sender, EventArgs e)
        {
            if (dgvGrades.CurrentRow != null && dgvGrades.CurrentRow.Cells["GRADE_DATE"].Value != DBNull.Value)
                dtpCalendar.Value = Convert.ToDateTime(dgvGrades.CurrentRow.Cells["GRADE_DATE"].Value);
        }

        private void DtpCalendar_ValueChanged(object? sender, EventArgs e)
        {
            if (dgvGrades.CurrentRow != null && userRole != "Student")
                dgvGrades.CurrentRow.Cells["GRADE_DATE"].Value = dtpCalendar.Value;
        }

        private void BtnSave_Click(object? sender, EventArgs e)
        {
            if (userRole == "Student") return;

            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();

                foreach (DataGridViewRow row in dgvGrades.Rows)
                {
                    if (row.IsNewRow) continue;

                    int gradeId = Convert.ToInt32(row.Cells["GRADEID"].Value);
                    int grade = Convert.ToInt32(row.Cells["GRADE"].Value);
                    int lecturerId = Convert.ToInt32(row.Cells["lecturer_col"].Value);
                    DateTime date = Convert.ToDateTime(row.Cells["GRADE_DATE"].Value);

                    string sql = "UPDATE ocenki SET grade = :g, grade_date = :d, lecturerid = :l WHERE gradeid = :gid";
                    using var cmd = new OracleCommand(sql, conn);
                    cmd.Parameters.Add("g", grade);
                    cmd.Parameters.Add("d", date);
                    cmd.Parameters.Add("l", lecturerId);
                    cmd.Parameters.Add("gid", gradeId);
                    cmd.ExecuteNonQuery();
                }

                MessageBox.Show("Grades updated successfully!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error saving grades: " + ex.Message);
            }
        }

        #endregion
    }
}
