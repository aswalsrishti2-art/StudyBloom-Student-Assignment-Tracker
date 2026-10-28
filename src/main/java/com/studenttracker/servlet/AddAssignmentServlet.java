
package com.studenttracker.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.studenttracker.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-assignment")
public class AddAssignmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Open the Add Assignment form
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("studentId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/add-assignment.jsp")
               .forward(request, response);
    }

    // Save the assignment
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("studentId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        int studentId =
            (Integer) session.getAttribute("studentId");

        String title = request.getParameter("title");
        String subject = request.getParameter("subject");
        String dueDate = request.getParameter("dueDate");

        if (title == null || title.trim().isEmpty()
                || subject == null || subject.trim().isEmpty()
                || dueDate == null || dueDate.trim().isEmpty()) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please fill in all fields.");
            return;
        }

        String sql = "INSERT INTO assignments " +
                "(student_id, subject, title, due_date, status) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setString(2, subject.trim());
            ps.setString(3, title.trim());
            ps.setDate(4, Date.valueOf(dueDate));
            ps.setString(5, "Pending");

            ps.executeUpdate();

            response.sendRedirect(
                request.getContextPath() + "/dashboard");

        } catch (IllegalArgumentException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please enter a valid due date.");

        } catch (SQLException e) {
            throw new ServletException(
                "Could not save the assignment to the database.", e);
        }
    }
}
