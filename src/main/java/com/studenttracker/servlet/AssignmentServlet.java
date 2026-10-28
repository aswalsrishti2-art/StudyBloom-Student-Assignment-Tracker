
package com.studenttracker.servlet;

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
import java.sql.Date;
import java.time.LocalDate;

@WebServlet("/assignments")
public class AssignmentServlet extends HttpServlet {

    private Integer getStudentId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object id = session.getAttribute("studentId");

        if (id instanceof Integer) {
            return (Integer) id;
        }

        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        Integer studentId = getStudentId(request);

        if (studentId == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        String sql = "SELECT assignment_id, subject, title, "
            + "due_date, status FROM assignments "
            + "WHERE student_id = ? ORDER BY due_date ASC";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                request.setAttribute("assignments", rs);
                request.getRequestDispatcher("/dashboard.jsp")
                    .forward(request, response);
            }

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load assignments.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Integer studentId = getStudentId(request);

        if (studentId == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try (Connection con = DatabaseConnection.getConnection()) {

            if ("add".equals(action)) {
                String subject = request.getParameter("subject");
                String title = request.getParameter("title");
                String dueDate = request.getParameter("dueDate");

                if (blank(subject) || blank(title)
                        || blank(dueDate)) {
                    response.sendError(400,
                        "All assignment fields are required.");
                    return;
                }

                LocalDate date = LocalDate.parse(dueDate);

                String sql = "INSERT INTO assignments "
                    + "(student_id, subject, title, due_date, status) "
                    + "VALUES (?, ?, ?, ?, 'Pending')";

                try (PreparedStatement ps =
                         con.prepareStatement(sql)) {
                    ps.setInt(1, studentId);
                    ps.setString(2, subject.trim());
                    ps.setString(3, title.trim());
                    ps.setDate(4, Date.valueOf(date));
                    ps.executeUpdate();
                }

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(
                    request.getParameter("assignmentId"));

                String subject = request.getParameter("subject");
                String title = request.getParameter("title");
                String dueDate = request.getParameter("dueDate");
                String status = request.getParameter("status");

                if (blank(subject) || blank(title)
                        || blank(dueDate)
                        || !("Pending".equals(status)
                        || "Completed".equals(status))) {
                    response.sendError(400,
                        "Invalid assignment details.");
                    return;
                }

                String sql = "UPDATE assignments SET subject = ?, "
                    + "title = ?, due_date = ?, status = ? "
                    + "WHERE assignment_id = ? AND student_id = ?";

                try (PreparedStatement ps =
                         con.prepareStatement(sql)) {
                    ps.setString(1, subject.trim());
                    ps.setString(2, title.trim());
                    ps.setDate(3,
                        Date.valueOf(LocalDate.parse(dueDate)));
                    ps.setString(4, status);
                    ps.setInt(5, id);
                    ps.setInt(6, studentId);
                    ps.executeUpdate();
                }

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(
                    request.getParameter("assignmentId"));

                String sql = "DELETE FROM assignments "
                    + "WHERE assignment_id = ? AND student_id = ?";

                try (PreparedStatement ps =
                         con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    ps.setInt(2, studentId);
                    ps.executeUpdate();
                }

            } else {
                response.sendError(400, "Unknown action.");
                return;
            }

            response.sendRedirect(
                request.getContextPath() + "/assignments");

        } catch (IllegalArgumentException e) {
            response.sendError(400, "Invalid date or assignment ID.");
        } catch (SQLException e) {
            throw new ServletException(
                "Unable to save assignment.", e);
        }
    }

    private boolean blank(String value) {
        return value == null || value.isBlank();
    }
}
