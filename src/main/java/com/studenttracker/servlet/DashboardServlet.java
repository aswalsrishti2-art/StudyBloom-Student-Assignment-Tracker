
package com.studenttracker.servlet;

import com.studenttracker.model.Assignment;
import com.studenttracker.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");
        String search = request.getParameter("search");

        if (search == null) {
            search = "";
        }
        search = search.trim();

        int total = 0;
        int completed = 0;
        int pending = 0;
        int overdue = 0;

        List<Assignment> assignments = new ArrayList<>();

        String statsSql =
            "SELECT COUNT(*) AS total, " +
            "COALESCE(SUM(CASE WHEN status = 'Completed' " +
            "THEN 1 ELSE 0 END), 0) AS completed, " +
            "COALESCE(SUM(CASE WHEN status <> 'Completed' " +
            "THEN 1 ELSE 0 END), 0) AS pending, " +
            "COALESCE(SUM(CASE WHEN status <> 'Completed' " +
            "AND due_date < CURDATE() THEN 1 ELSE 0 END), 0) AS overdue " +
            "FROM assignments WHERE student_id = ?";

        String listSql =
            "SELECT assignment_id, subject, title, due_date, status " +
            "FROM assignments WHERE student_id = ? " +
            "AND (title LIKE ? OR subject LIKE ? OR status LIKE ?) " +
            "ORDER BY (status = 'Completed') ASC, due_date ASC";

        try (Connection con = DatabaseConnection.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement(statsSql)) {
                ps.setInt(1, studentId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        total = rs.getInt("total");
                        completed = rs.getInt("completed");
                        pending = rs.getInt("pending");
                        overdue = rs.getInt("overdue");
                    }
                }
            }

            try (PreparedStatement ps = con.prepareStatement(listSql)) {
                String keyword = "%" + search + "%";

                ps.setInt(1, studentId);
                ps.setString(2, keyword);
                ps.setString(3, keyword);
                ps.setString(4, keyword);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        assignments.add(new Assignment(
                            rs.getInt("assignment_id"),
                            rs.getString("subject"),
                            rs.getString("title"),
                            rs.getDate("due_date"),
                            rs.getString("status")
                        ));
                    }
                }
            }

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load the dashboard. Check the database connection and table structure.",
                e
            );
        }

        int progress = total == 0
                ? 0
                : (int) Math.round(completed * 100.0 / total);

        request.setAttribute("assignments", assignments);
        request.setAttribute("total", total);
        request.setAttribute("completed", completed);
        request.setAttribute("pending", pending);
        request.setAttribute("overdue", overdue);
        request.setAttribute("progress", progress);
        request.setAttribute("search", search);

        request.getRequestDispatcher("/dashboard.jsp")
               .forward(request, response);
    }
}
