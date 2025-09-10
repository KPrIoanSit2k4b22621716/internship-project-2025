using System;
using System.Data;
using System.Drawing;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace InternshipProjectStatusDB
{
    public partial class StudentGradesForm : Form
    {
        private readonly int studentId;
        private readonly string connectionString = "User Id=INTERNSHIP_USER;Password=neznam11;Data Source=localhost:1521/xe;";

        private Label lblTitle = new Label();
        private Label lblAverage = new Label();
        private DataGridView dgvGrades = new DataGridView();
        private Button btnClose = new Button();

        public StudentGradesForm(int studentId)
        {
            this.studentId = studentId;

            InitializeComponent();
            SetupUI();
            LoadGrades();
        }

        private void SetupUI()
        {
            this.Text = "Student Grades";
            this.Size = new Size(700, 500);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.BackColor = Color.White;

            // Title
            lblTitle.Text = "Your Grades";
            lblTitle.Font = new Font("Segoe UI", 14F, FontStyle.Bold);
            lblTitle.ForeColor = Color.DarkBlue;
            lblTitle.AutoSize = true;
            lblTitle.Location = new Point(20, 20);

            // Average Label
            lblAverage.Text = "Average Grade: ";
            lblAverage.Font = new Font("Segoe UI", 10F, FontStyle.Bold);
            lblAverage.ForeColor = Color.DarkGreen;
            lblAverage.AutoSize = true;
            lblAverage.Location = new Point(20, 60);

            // DataGridView
            dgvGrades.Location = new Point(20, 100);
            dgvGrades.Size = new Size(650, 300);
            dgvGrades.ReadOnly = true;
            dgvGrades.AllowUserToAddRows = false;
            dgvGrades.AllowUserToDeleteRows = false;
            dgvGrades.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvGrades.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;

            // Close Button
            btnClose.Text = "Close";
            btnClose.Size = new Size(100, 30);
            btnClose.Location = new Point((this.ClientSize.Width - btnClose.Width) / 2, 420);
            btnClose.BackColor = Color.SteelBlue;
            btnClose.ForeColor = Color.White;
            btnClose.FlatStyle = FlatStyle.Flat;
            btnClose.Click += (s, e) => this.Close();

            this.Controls.Add(lblTitle);
            this.Controls.Add(lblAverage);
            this.Controls.Add(dgvGrades);
            this.Controls.Add(btnClose);
        }

        private void LoadGrades()
        {
            try
            {
                using var conn = new OracleConnection(connectionString);
                conn.Open();

                string query = @"
                    SELECT sub.name AS Subject, o.grade AS Grade, o.grade_date AS GradeDate, 
                           l.firstname || ' ' || l.lastname AS Lecturer
                    FROM ocenki o
                    JOIN predmeti sub ON o.subjectid = sub.subjectid
                    JOIN lecturers l ON o.lecturerid = l.lecturerid
                    WHERE o.studentid = :studentId
                    ORDER BY sub.name";

                using var cmd = new OracleCommand(query, conn);
                cmd.Parameters.Add("studentId", OracleDbType.Int32).Value = studentId;

                using var adapter = new OracleDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                dgvGrades.DataSource = dt;

                // Calculate average
                double avg = 0;
                if (dt.Rows.Count > 0)
                {
                    double sum = 0;
                    int count = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        if (double.TryParse(row["Grade"].ToString(), out double g))
                        {
                            sum += g;
                            count++;
                        }
                    }
                    avg = count > 0 ? sum / count : 0;
                }
                lblAverage.Text = $"Average Grade: {avg:F2}";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading grades: " + ex.Message);
            }
        }
    }
}
