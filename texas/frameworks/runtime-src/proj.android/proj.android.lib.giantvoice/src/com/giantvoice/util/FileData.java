package com.giantvoice.util;

public class FileData {
    private String url;
    private String duration;
    private String filesize;
    private String labelid;
    private String text;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getFilesize() {
        return filesize;
    }

    public void setFilesize(String filesize) {
        this.filesize = filesize;
    }

    public String getLabelid() {
        return labelid;
    }

    public void setLabelid(String labelid) {
        this.labelid = labelid;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    @Override
    public String toString() {
        return "FileData{" +
                "url='" + url + '\'' +
                ", duration='" + duration + '\'' +
                ", filesize='" + filesize + '\'' +
                ", labelid='" + labelid + '\'' +
                ", text='" + text + '\'' +
                '}';
    }
}
