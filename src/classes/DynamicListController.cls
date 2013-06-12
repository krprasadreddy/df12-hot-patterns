public virtual class DynamicListController {
    private ApexPages.StandardSetController controller;
    private String baseQuery;
    public String nameSearchFld {get; set;}

    //** constructor
    public DynamicListController(String baseQuery) {
        this.baseQuery = baseQuery;
        // query(); // lazy loading - don't query until the Search function is invoked 
    }

    //** query methods
    protected void query() {
        // construct the query string
        String queryString = baseQuery + ' ' + getWhereClause() + ' ' + getSortClause() + ' limit 10000';
        System.debug('queryString: ' + queryString);

        // save pageSize
        Integer pageSize = this.pageSize;

        // reboot standard set controller
        controller = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));

        // reset pageSize
        controller.setPageSize(pageSize);
    }

    //** search methods
    public PageReference search() {
        query();

        // return to same page
        return null;
    }

    // override to construct dynamic SOQL where clause 
    protected virtual String getWhereClause() {
        if (nameSearchFld != null && nameSearchFld.trim() != '')
            return 'where Name like :nameSearchFld ';
        else return '';
    }

    //** sort methods
    public String sortColumn {
        get {
            if (sortColumn == null) sortColumn = '';
            return sortColumn;
        }
        set {
            if (sortColumn != value) sortAsc = false;
            sortColumn = value;
        }
    }

    public Boolean sortAsc {
        get {
            if (sortAsc == null) sortAsc = false;
            return sortAsc;
        } 
        set;
    }

    public PageReference sort() {
        sortAsc = !sortAsc;

        query();

        // return to same page
        return null;
    }

    protected virtual String getSortClause() {
        if (sortColumn == '') return '';
        else return ' order by ' + sortColumn + (sortAsc ? ' asc ' : ' desc ') + ' nulls last';
    }

    //** pageable methods
    // get records on current page 
    protected List<SObject> getRecords() {
        if (controller != null)
            return controller.getRecords();
        else
            return new List<SObject>();
    }

    public void first() {
        controller.first();
    }

    public void previous() {
        controller.previous();
    }

    public void next() {
        controller.next();
    }

    public void last() {
        controller.last();
    }

    public Boolean getHasPrevious() {
        if (controller != null)
            return controller.getHasPrevious();
        else
            return false;
    }

    public Boolean getHasNext() {
        if (controller != null)
            return controller.getHasNext();
        else
            return false;
    }

    public Integer getResultSize() {
        if (controller != null)
            return controller.getResultSize();
        else
            return 0;
    }

    public Integer getPageCount() {
        if (controller == null) {
            return 0;
        } else {
            Integer resultSize = getResultSize();
    
            Integer oddRecordCount = Math.mod(resultSize, pageSize);
            return ((resultSize - oddRecordCount) / pageSize) + (oddRecordCount > 0 ? 1 : 0);
        }
    }

    public Integer getPageNumber() {
        if (controller != null)
            return controller.getPageNumber();
        else
            return 0;
    }

    public void setPageNumber(Integer pageNumber) {
        controller.setPageNumber(pageNumber);
    }

    public Integer pageSize {
        get {
            if (pageSize != null)
                return pageSize;
            else if (controller != null) 
                pageSize = controller.getPageSize();
            else
                // default pagesize
                pageSize = 20; 

            return pageSize;
        }

        set {
            pageSize = value;
            
            if (controller != null)
                controller.setPageSize(pageSize);
        }
    }

    public Boolean getRenderResults() {
        return (getResultSize() > 0);
    }

    //** update methods
    public virtual PageReference save() {
        return controller.save();
    }

    public virtual PageReference cancel() {
        return controller.cancel();
    }

    //** pass reference to dynamic paginator component 
    public DynamicListController getController () {
        return this;
    }
}