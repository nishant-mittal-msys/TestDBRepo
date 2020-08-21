USE [FPCAPPS]
GO
CREATE NONCLUSTERED INDEX [ALLCATS_LineReview101_pdslc]
ON [sicf].[ALLCATS_LineReview101] ([Pool])
INCLUDE ([Part Number],[DC Stock Count],[S],[L12 Units],[Current NPM Part Type])
GO

USE [FPCAPPS]
GO
CREATE NONCLUSTERED INDEX [ix_ALLCATS_LineReview101_PoolPartNo]
ON sicf.ALLCATS_LineReview101 ([Pool], [Part Number])
INCLUDE ([DC Stock Count], [S], [L12 Units], [L12 Revenue])
GO

