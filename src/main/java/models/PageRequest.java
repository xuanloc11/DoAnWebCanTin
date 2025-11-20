package models;

public class PageRequest {
    private final int page; // 1-based
    private final int size;

    public PageRequest(int page, int size) {
        this.page = page <= 0 ? 1 : page;
        this.size = size <= 0 ? 10 : size;
    }

    public int getPage() { return page; }
    public int getSize() { return size; }

    public int getOffset() {
        return (page - 1) * size;
    }
}
