public interface IListController {
    void query();
    PageReference search();
    String getWhereClause();
    PageReference sort();
    String getSortClause();
    List<SObject> getRecords();
    void first();
    void previous();
    void next();
    void last();
    Boolean getHasPrevious();
    Boolean getHasNext();
    Integer getResultSize();
    Integer getPageCount();
    Integer getPageNumber();
    void setPageNumber(Integer pageNumber);
    Boolean getRenderResults();
    PageReference save();
    PageReference cancel();
    DynamicListController getController();
}