package models;

import java.util.Collections;
import java.util.List;

public class Page<T> {
    private final List<T> content;
    private final int pageNumber; // 1-based
    private final int pageSize;
    private final long totalElements;

    public Page(List<T> content, int pageNumber, int pageSize, long totalElements) {
        this.content = content == null ? Collections.emptyList() : content;
        this.pageNumber = Math.max(1, pageNumber);
        this.pageSize = Math.max(1, pageSize);
        this.totalElements = Math.max(0, totalElements);
    }

    public List<T> getContent() { return content; }
    public int getPageNumber() { return pageNumber; }
    public int getPageSize() { return pageSize; }
    public long getTotalElements() { return totalElements; }

    public int getTotalPages() {
        if (pageSize <= 0) return 0;
        return (int) Math.ceil((double) totalElements / (double) pageSize);
    }

    public boolean isFirst() { return pageNumber <= 1; }
    public boolean isLast() { return pageNumber >= getTotalPages(); }
}
