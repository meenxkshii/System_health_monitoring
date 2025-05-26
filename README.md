# Linux System Health Monitor

A simple yet robust Bash script to monitor critical system metrics (CPU, Memory, Disk) on a Linux server and send email alerts if predefined thresholds are exceeded. This project demonstrates fundamental Linux command-line skills, Bash scripting, and automation using corn.
![Screenshot 2025-05-26 214812](https://github.com/user-attachments/assets/df1db648-4911-40f2-a136-76ae384e3174)

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

    After the `system_monitor.sh` script has run at least once (either manually or via cron), it will generate `current_metrics.json` and `metrics_history.csv` in the same directory.

    **Recommended Way (Most Reliable): Use a Local Web Server**
    For the dashboard to properly load data from local files, it's best to serve it using a simple HTTP server.
    1.  Open your terminal and navigate to your `devops_projects` directory:
        ```bash
        cd ~/devops_projects
        ```
    2.  Start a simple Python HTTP server (leave this terminal window open):
        ```bash
        python3 -m http.server 8000
        ```
    3.  Open your web browser and navigate to:
        ```
        http://localhost:8000/dashboard.html
        ```
    4.  To stop the server, press `Ctrl+C` in the terminal where it's running.

    **Alternative for WSL Users (via Windows Explorer):**
    If you are using WSL, you can often open `dashboard.html` directly via your Windows File Explorer:
    1.  Open Windows File Explorer.
    2.  In the address bar, type `\\wsl$` and press Enter.
    3.  Navigate to your Linux distribution (e.g., `Ubuntu`).
    4.  Browse to `home` -> `your_username` -> `devops_projects`.
    5.  Double-click `dashboard.html`.

    **Note on `xdg-open` / Graphical Browsers:**
    If you attempt to use `xdg-open ~/devops_projects/dashboard.html` and encounter errors like `xdg-open: no method available...` or "browser not found", it typically means you do not have a graphical web browser installed in your Linux environment or your desktop environment is not configured.
    * **Solution (for Linux VMs with a GUI):** Install a browser like Firefox: `sudo apt update && sudo apt install firefox -y`.
    * **Solution (for headless servers):** The local web server method (as described above) is the appropriate way to preview the dashboard.
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

## License

This project is open-source and available under the [MIT License].
