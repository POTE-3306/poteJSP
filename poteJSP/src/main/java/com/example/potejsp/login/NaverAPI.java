package com.example.potejsp.login;

import com.example.potejsp.domain.APIUser;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

public class NaverAPI {

    public static String clientId = "Jk8YyGTHPTXQve0hOdFX";
    public static String clientSecret = "lnMtWBOKIJ";
    public static String redirectURI;

    static {
        try {
            redirectURI = URLEncoder.encode("http://localhost:8080/pote/login.jsp", "UTF-8");
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
    }

    public static APIUser getProfile(String accessToken) throws Exception {
        String header = "Bearer " + accessToken; // Bearer 다음에 공백 추가
        String apiURL = "https://openapi.naver.com/v1/nid/me";
        Map<String, String> requestHeaders = new HashMap<>();
        requestHeaders.put("Authorization", header);
        String responseBody = get(apiURL,requestHeaders);
        APIUser apiUser = null;
        try {
            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> map = mapper.readValue(responseBody, Map.class);
            Map<String, String> responseMap = (Map<String, String>) map.get("response");
            apiUser = new APIUser();
            apiUser.setNaverId(responseMap.get("id"));
            apiUser.setEmail(responseMap.get("email"));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return apiUser;
    }

    private static String get(String apiUrl, Map<String, String> requestHeaders) throws Exception {
        HttpURLConnection con = connect(apiUrl);
        try {
            con.setRequestMethod("GET");
            for(Map.Entry<String, String> header :requestHeaders.entrySet()) {
                con.setRequestProperty(header.getKey(), header.getValue());
            }
            int responseCode = con.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
                return readBody(con.getInputStream());
            } else { // 에러 발생
                return readBody(con.getErrorStream());
            }
        } catch (IOException e) {
            throw new RuntimeException("API 요청과 응답 실패", e);
        } finally {
            con.disconnect();
        }
    }


    private static HttpURLConnection connect(String apiUrl) throws Exception {
        try {
            URL url = new URL(apiUrl);
            return (HttpURLConnection)url.openConnection();
        } catch (MalformedURLException e) {
            throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
        } catch (IOException e) {
            throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
        }
    }


    private static String readBody(InputStream body) throws Exception {
        InputStreamReader streamReader = new InputStreamReader(body);

        try (BufferedReader lineReader = new BufferedReader(streamReader)) {
            StringBuilder responseBody = new StringBuilder();
            String line;
            while ((line = lineReader.readLine()) != null) {
                responseBody.append(line);
            }
            return responseBody.toString();
        } catch (IOException e) {
            throw new RuntimeException("API 응답을 읽는데 실패했습니다.", e);
        }
    }
}
