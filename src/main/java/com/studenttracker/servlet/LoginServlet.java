
package com.studenttracker.servlet;

import com.studenttracker.util.DatabaseConnection;
import com.studenttracker.util.PasswordUtil;

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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        String sql = "SELECT student_id, name, password_hash "
                   + "FROM students WHERE email = ?";

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email.trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next() && PasswordUtil.verifyPassword(
                        password, rs.getString("password_hash"))) {

                    // Invalidate any previous session
                    HttpSession oldSession = request.getSession(false);

                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    // Create a new session for the logged-in student
                    HttpSession session = request.getSession(true);

                    session.setAttribute(
                        "studentId", rs.getInt("student_id"));

                    session.setAttribute(
                        "studentName", rs.getString("name"));

                    session.setMaxInactiveInterval(30 * 60);

                    response.sendRedirect(
                        request.getContextPath() + "/dashboard");
                    return;

                } else {
                    request.setAttribute("error",
                        "Incorrect email or password.");

                    request.getRequestDispatcher("/login.jsp")
                           .forward(request, response);
                }
            }

        } catch (Exception e) {
            throw new ServletException(
                "Unable to log in.", e);
        }
    }
}
