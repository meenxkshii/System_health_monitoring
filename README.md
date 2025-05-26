# Linux System Health Monitor

A simple yet robust Bash script to monitor critical system metrics (CPU, Memory, Disk) on a Linux server and send email alerts if predefined thresholds are exceeded. This project demonstrates fundamental Linux command-line skills, Bash scripting, and automation using cron.

## Features

* Monitors CPU, Memory, and Root Disk usage.
* Configurable thresholds for each metric.
* Sends email alerts when thresholds are breached.
* Automated scheduling via Cron.
* Provides a simple web dashboard for real-time and historical metric visualization.

## Technologies Used

* **Linux:** Debian/Ubuntu (tested on Ubuntu 22.04 LTS)
* **Bash Scripting:** For automation and logic.
* **Core Utilities:** `top`, `free`, `df`, `grep`, `awk`, `sed`, `cut`.
* **Cron:** For scheduling the script to run periodically.
* **mailutils (mailx):** For sending email alerts.
* **Git & GitHub:** For version control and project hosting.

## Prerequisites

* A Linux server (VM, cloud instance, or WSL).
* `mailutils` package installed for email alerts (`sudo apt install mailutils`).

## Installation and Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your_username/your_repo_name.git](https://github.com/your_username/your_repo_name.git)
    cd your_repo_name # Replace with your actual repo name, e.g., linux-system-monitor
    ```

2.  **Make the script executable:**
    ```bash
    chmod +x system_monitor.sh
    ```

3.  **Configure the script:**
    Open `system_monitor.sh` in a text editor and adjust the following variables:
    * `CPU_THRESHOLD`: (e.g., 80 for 80%)
    * `MEM_THRESHOLD`: (e.g., 80 for 80%)
    * `DISK_THRESHOLD`: (e.g., 90 for 90%)
    * `RECIPIENT_EMAIL`: **Change this to your actual email address!** (e.g., `your.name@example.com`)

4.  **Test the script manually (optional):**
    You can temporarily lower thresholds in the script to trigger alerts for testing.
    ```bash
    ./system_monitor.sh
    ```
    Check your terminal output and email for alerts.

5.  **Schedule with Cron:**
    To run the script automatically, open your crontab:
    ```bash
    crontab -e
    ```
    Add the following line to run the script every 5 minutes (adjust the path to your script):
    ```cron
    */5 * * * * /home/your_username/your_repo_name/system_monitor.sh >> /var/log/system_monitor.log 2>&1
    ```
    * **Remember to replace `/home/your_username/your_repo_name/` with the actual path to your cloned repository.**
    * Save and exit the crontab editor.

6.  **View the Web Dashboard:**
    After the `system_monitor.sh` script has run a few times (either manually or via cron), it will generate `current_metrics.json` and `metrics_history.csv` in the same directory.
    You can then open `dashboard.html` directly in your web browser to view the metrics:
    ```bash
    xdg-open ~/devops_projects/dashboard.html
    ```
    (Replace `~/devops_projects/` with the actual path if you cloned it elsewhere).
    Click the "Refresh Data" button on the dashboard to load the latest metrics.

## How it Works (Learning Outcomes)

This project enhanced my understanding of:

* **Linux System Commands:** Deep dive into `top`, `free`, `df` for system resource inspection.
* **Text Processing:** Advanced usage of `grep`, `awk`, `sed`, and `cut` for extracting and manipulating data from command outputs.
* **Bash Scripting Fundamentals:** Variables, functions, conditional statements (`if`), and basic error handling.
* **Process Automation:** Utilizing `cron` for reliable, scheduled execution of tasks.
* **Email Integration:** Sending system-generated alerts via `mailx` (mailutils).
* **Version Control:** Managing project changes and collaboration using Git and GitHub.

## Future Enhancements

* Integrate with Slack or other messaging platforms for alerts using webhooks.
* Store historical metric data in a simple database (e.g., SQLite) or CSV for trend analysis.
* Add monitoring for other services (e.g., web server status, specific process checks).
* Implement a more sophisticated logging mechanism.
* Create a simple web dashboard to visualize metrics.

## License

This project is open-source and available under the [MIT License](LICENSE) (You can add a LICENSE file later).
