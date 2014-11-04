formatReturnProductSearch = (item) ->
  "#{item.name} [#{item.skulls}] - [giảm giá: #{Math.round(item.discountPercent*100)/100}% - số lượng: #{item.quality - item.returnQuality}]" if item

Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.returnProductSelectOptions=
      query: (query) -> query.callback
        results: Session.get('currentSaleProductDetails')
      initSelection: (element, callback) -> callback(Schema.saleDetails.findOne(Session.get('currentSale')?.currentProductDetail))
      formatSelection: formatReturnProductSearch
      formatResult: formatReturnProductSearch
      placeholder: 'CHỌN SẢN PHẨM'
  #    minimumResultsForSearch: -1
      hotkey: 'return'
      changeAction: (e) ->
        Schema.sales.update(Session.get('currentSale')._id, {$set: {
          currentProductDetail: e.added._id
          currentQuality: 1
        }})
      reactiveValueGetter: -> Session.get('currentSale')?.currentProductDetail