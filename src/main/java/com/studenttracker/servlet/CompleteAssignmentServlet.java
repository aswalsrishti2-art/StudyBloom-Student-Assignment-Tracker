
package com.studenttracker.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.studenttracker.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/complete-assignment")
public class CompleteAssignmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("studentId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int studentId = Integer.parseInt(
                session.getAttribute("studentId").toString()
            );

            int assignmentId = Integer.parseInt(
                request.getParameter("assignmentId")
            );

            String status = request.getParameter("status");

            if (!"Completed".equals(status) && !"Pending".equals(status)) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid assignment status"
                );
                return;
            }

            String sql = "UPDATE assignments SET status = ? "
                       + "WHERE assignment_id = ? AND student_id = ?";

            try (Connection con = DatabaseConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, status);
                ps.setInt(2, assignmentId);
                ps.setInt(3, studentId);
                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/dashboard");

        } catch (NumberFormatException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid assignment ID"
            );
        } catch (Exception e) {
            throw new ServletException(
                "Unable to update assignment status", e
            );
        }
    }
}
