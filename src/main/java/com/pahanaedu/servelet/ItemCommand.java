package com.pahanaedu.servelet;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
public interface ItemCommand {
    void execute(HttpServletRequest request, ServletContext context);
}
