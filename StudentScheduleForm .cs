using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class StudentScheduleForm : Form
    {
        private readonly int studentId;
        private readonly string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        private Label lblTitle = new Label();
        private DataGridView dgvSchedule = new DataGridView();
        private Button btnClose = new Button();

        public StudentScheduleForm(int studentId)
        {
            this.studentId = studentId;

            InitializeComponent();
            SetupUI();
            LoadSchedule();
        }

        private void SetupUI()
        {
            this.Text = "Student Schedule";
            this.Size = new Size(700, 500);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.BackColor = Color.White;

            // Title label
            lblTitle.Text = "Your Schedule";
            lblTitle.Font = new Font("Segoe UI", 14F, FontStyle.Bold);
            lblTitle.ForeColor = Color.DarkBlue;
            lblTitle.AutoSize = true;
            lblTitle.Location = new Point(20, 20);
            this.Controls.Add(lblTitle);

            // DataGridView
            dgvSchedule.Location = new Point(20, 60);
            dgvSchedule.Size = new Size(650, 350);
            dgvSchedule.ReadOnly = true;
            dgvSchedule.AllowUserToAddRows = false;
            dgvSchedule.AllowUserToDeleteRows = false;
            dgvSchedule.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvSchedule.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dgvSchedule.RowPrePaint += DgvSchedule_RowPrePaint;
            this.Controls.Add(dgvSchedule);

            // Close button
            btnClose.Text = "Close";
            btnClose.Size = new Size(100, 30);
            btnClose.Location = new Point((this.ClientSize.Width - btnClose.Width) / 2, 420);
            btnClose.BackColor = Color.SteelBlue;
            btnClose.ForeColor = Color.White;
            btnClose.FlatStyle = FlatStyle.Flat;
            btnClose.Click += (s, e) => this.Close();
            this.Controls.Add(btnClose);
        }

        private void LoadSchedule()
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();

                string query = @"
                    SELECT sub.name AS Subject, p.day AS Day, p.hour AS Hour,
                           l.firstname || ' ' || l.lastname AS Lecturer,
                           p.type
                    FROM programi p
                    JOIN students s ON p.groupid = s.groupid
                    JOIN predmeti sub ON p.subjectid = sub.subjectid
                    JOIN lecturers l ON p.lecturerid = l.lecturerid
                    WHERE s.studentid = :studentId
                    ORDER BY 
                        CASE p.day
                            WHEN 'Monday' THEN 1
                            WHEN 'Tuesday' THEN 2
                            WHEN 'Wednesday' THEN 3
                            WHEN 'Thursday' THEN 4
                            WHEN 'Friday' THEN 5
                            ELSE 6
                        END, p.hour";

                using var cmd = new OracleCommand(query, conn);
                cmd.Parameters.Add("studentId", OracleDbType.Int32).Value = studentId;

                using var adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                dgvSchedule.DataSource = dt;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading schedule: " + ex.Message);
            }
        }

        private void DgvSchedule_RowPrePaint(object? sender, DataGridViewRowPrePaintEventArgs e)
        {
            var typeValue = dgvSchedule.Rows[e.RowIndex].Cells["type"].Value;
            string type = typeValue?.ToString() ?? "";

            if (type == "Lecture")
                dgvSchedule.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.LightBlue;
            else if (type == "Exercise")
                dgvSchedule.Rows[e.RowIndex].DefaultCellStyle.BackColor = Color.LightGreen;

            var dayValue = dgvSchedule.Rows[e.RowIndex].Cells["day"].Value;
            string day = dayValue?.ToString() ?? "";
            string today = DateTime.Now.DayOfWeek.ToString();

            if (day.Equals(today, StringComparison.OrdinalIgnoreCase))
            {
                dgvSchedule.Rows[e.RowIndex].DefaultCellStyle.Font = new Font(dgvSchedule.Font, FontStyle.Bold);
                dgvSchedule.Rows[e.RowIndex].DefaultCellStyle.ForeColor = Color.DarkRed;
            }
        }
    }
}
