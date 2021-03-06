class QgsPointDisplacementRenderer : QgsFeatureRenderer
{
%TypeHeaderCode
#include <qgspointdisplacementrenderer.h>
%End
  public:

    /** Placement methods for dispersing points
     */
    enum Placement
    {
      Ring, /*!< Place points in a single ring around group*/
      ConcentricRings /*!< Place points in concentric rings around group*/
    };

    QgsPointDisplacementRenderer( const QString& labelAttributeName = "" );
    ~QgsPointDisplacementRenderer();

    virtual QgsPointDisplacementRenderer* clone() const /Factory/;

    virtual void toSld( QDomDocument& doc, QDomElement &element ) const;

    /** Reimplemented from QgsFeatureRenderer*/
    bool renderFeature( QgsFeature& feature, QgsRenderContext& context, int layer = -1, bool selected = false, bool drawVertexMarker = false );

    /** Partial proxy that will call this method on the embedded renderer. */
    virtual QList<QString> usedAttributes();
    /** Proxy that will call this method on the embedded renderer. */
    virtual QgsFeatureRenderer::Capabilities capabilities();
    /** Proxy that will call this method on the embedded renderer.
      @note available in python as symbols2
     */
    virtual QgsSymbolList symbols( QgsRenderContext& context ) /PyName=symbols2/;
    /** Proxy that will call this method on the embedded renderer.
      @note available in python as symbolForFeature2
     */
    virtual QgsSymbol* symbolForFeature( QgsFeature& feature, QgsRenderContext& context ) /PyName=symbolForFeature2/;
    /** Proxy that will call this method on the embedded renderer.
      @note available in python as originalSymbolForFeature2
     */
    virtual QgsSymbol* originalSymbolForFeature( QgsFeature& feat, QgsRenderContext& context ) /PyName=originalSymbolForFeature2/;
    /** Proxy that will call this method on the embedded renderer.
      @note available in python as symbolsForFeature2
     */
    virtual QgsSymbolList symbolsForFeature( QgsFeature& feat, QgsRenderContext& context ) /PyName=symbolsForFeature2/;
    /** Proxy that will call this method on the embedded renderer.
      @note available in python as originalSymbolsForFeature2
     */
    virtual QgsSymbolList originalSymbolsForFeature( QgsFeature& feat, QgsRenderContext& context ) /PyName=originalSymbolsForFeature2/;
    /** Proxy that will call this method on the embedded renderer.
      @note available in python as willRenderFeature2
     */
    virtual bool willRenderFeature( QgsFeature& feat, QgsRenderContext& context ) /PyName=willRenderFeature2/;

    virtual void startRender( QgsRenderContext& context, const QgsFields& fields );

    void stopRender( QgsRenderContext& context );

    //! create a renderer from XML element
    static QgsFeatureRenderer* create( QDomElement& symbologyElem ) /Factory/;
    QDomElement save( QDomDocument& doc );

    QgsLegendSymbologyList legendSymbologyItems( QSize iconSize );

    //! @note not available in python bindings
    // QgsLegendSymbolList legendSymbolItems();

    void setLabelAttributeName( const QString& name );
    QString labelAttributeName() const;

    void setEmbeddedRenderer( QgsFeatureRenderer* r /Transfer/ );
    const QgsFeatureRenderer* embeddedRenderer() const;

    virtual void setLegendSymbolItem( const QString& key, QgsSymbol* symbol );

    virtual bool legendSymbolItemsCheckable() const;
    virtual bool legendSymbolItemChecked( const QString& key );
    virtual void checkLegendSymbolItem( const QString& key, bool state = true );

    //! not available in python bindings
    //! @deprecated since 2.4
    // void setDisplacementGroups( const QList<QMap<QgsFeatureId, QgsFeature> >& list );

    void setLabelFont( const QFont& f );
    QFont labelFont() const;

    void setCircleWidth( double w );
    double circleWidth() const;

    void setCircleColor( const QColor& c );
    QColor circleColor() const;

    void setLabelColor( const QColor& c );
    QColor labelColor() const;

    void setCircleRadiusAddition( double d );
    double circleRadiusAddition() const;

    void setMaxLabelScaleDenominator( double d );
    double maxLabelScaleDenominator() const;

    /** Returns the placement method used for dispersing the points.
     * @see setPlacement()
     * @note added in QGIS 2.12
     */
    Placement placement() const;

    /** Sets the placement method used for dispersing the points.
     * @param placement placement method
     * @see placement()
     * @note added in QGIS 2.12
     */
    void setPlacement( Placement placement );

    /** Returns the symbol for the center of a displacement group (but _not_ ownership of the symbol)*/
    QgsMarkerSymbol* centerSymbol();
    /** Sets the center symbol (takes ownership)*/
    void setCenterSymbol( QgsMarkerSymbol* symbol /Transfer/ );

    /** Sets the tolerance distance for grouping points. Units are specified using
     * setToleranceUnit().
     * @param t tolerance distance
     * @see tolerance()
     * @see setToleranceUnit()
     */
    void setTolerance( double t );

    /** Returns the tolerance distance for grouping points. Units are retrieved using
     * toleranceUnit().
     * @see setTolerance()
     * @see toleranceUnit()
     */
    double tolerance() const;

    /** Sets the units for the tolerance distance.
     * @param unit tolerance distance units
     * @see setTolerance()
     * @see toleranceUnit()
     * @note added in QGIS 2.12
     */
    void setToleranceUnit( QgsUnitTypes::RenderUnit unit );

    /** Returns the units for the tolerance distance.
     * @see tolerance()
     * @see setToleranceUnit()
     * @note added in QGIS 2.12
     */
    QgsUnitTypes::RenderUnit toleranceUnit() const;

    /** Sets the map unit scale object for the distance tolerance. This is only used if the
     * toleranceUnit() is set to QgsSymbol::MapUnit.
     * @param scale scale for distance tolerance
     * @see toleranceMapUnitScale()
     * @see setToleranceUnit()
     */
    void setToleranceMapUnitScale( const QgsMapUnitScale& scale );

    /** Returns the map unit scale object for the distance tolerance. This is only used if the
     * toleranceUnit() is set to QgsSymbol::MapUnit.
     * @see setToleranceMapUnitScale()
     * @see toleranceUnit()
     */
    const QgsMapUnitScale& toleranceMapUnitScale() const;

    //! creates a QgsPointDisplacementRenderer from an existing renderer.
    //! @note added in 2.5
    //! @returns a new renderer if the conversion was possible, otherwise 0.
    static QgsPointDisplacementRenderer* convertFromRenderer(const QgsFeatureRenderer *renderer ) /Factory/;

  private:
    QgsPointDisplacementRenderer( const QgsPointDisplacementRenderer & );
    QgsPointDisplacementRenderer & operator=( const QgsPointDisplacementRenderer & );
};
