
package com.studenttracker.model;

import java.sql.Date;

public class Assignment {

    private int assignmentId;
    private String subject;
    private String title;
    private Date dueDate;
    private String status;

    public Assignment(int assignmentId, String subject,
                      String title, Date dueDate, String status) {
        this.assignmentId = assignmentId;
        this.subject = subject;
        this.title = title;
        this.dueDate = dueDate;
        this.status = status;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public String getSubject() {
        return subject;
    }

    public String getTitle() {
        return title;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public String getStatus() {
        return status;
    }

    public boolean isCompleted() {
        return "Completed".equalsIgnoreCase(status);
    }

    public boolean isOverdue() {
        return !isCompleted()
                && dueDate != null
                && dueDate.before(new Date(System.currentTimeMillis()));
    }
}
