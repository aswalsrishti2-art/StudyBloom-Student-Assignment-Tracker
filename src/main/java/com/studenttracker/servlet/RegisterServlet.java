
package com.studenttracker.servlet;

import com.studenttracker.util.DatabaseConnection;
import com.studenttracker.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (name == null || email == null || password == null
                || name.isBlank() || email.isBlank()
                || password.length() < 8) {

            request.setAttribute("error",
                "Enter your name, email, and a password of at least 8 characters.");
            request.getRequestDispatcher("/register.jsp")
                .forward(request, response);
            return;
        }

        try {
            String hashedPassword =
                PasswordUtil.hashPassword(password);

            String sql = "INSERT INTO students "
                + "(name, email, password_hash) VALUES (?, ?, ?)";

            try (Connection con = DatabaseConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, name.trim());
                ps.setString(2, email.trim().toLowerCase());
                ps.setString(3, hashedPassword);

                ps.executeUpdate();
            }

            response.sendRedirect(
                request.getContextPath() + "/login.jsp?registered=1");

        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
            request.setAttribute("error",
                "This email is already registered.");
            request.getRequestDispatcher("/register.jsp")
                .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to register student.", e);
        }
    }
}
