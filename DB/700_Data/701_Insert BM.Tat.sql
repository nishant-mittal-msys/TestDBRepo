use fpcapps

DELETE FROM BM.Tat

INSERT INTO BM.Tat(BidStatus, BidSizeStart, BidSizeEnd, TatDays)
VALUES
--range 1 to 25
('CrowdSourcing', 1, 25, 1)
,('CrossFinalization', 1, 25, 2)
,('CategoryManager', 1, 25, 2)
,('PricingTeam', 1, 25, 6)
--,('PricingTeam', 1, 25, 2)
--,('Review', 1, 25, 4)
--range 26 to 500
,('CrowdSourcing', 26, 500, 1)
,('CrossFinalization',26, 500, 3)
,('CategoryManager', 26, 500, 3)
,('PricingTeam', 26, 500, 7)
--,('PricingTeam', 26, 500, 3)
--,('Review', 26, 500, 4)
--range 500 to max
,('CrowdSourcing', 500, 2147483647, 1)
,('CrossFinalization',  500, 2147483647, 5)
,('CategoryManager', 500, 2147483647, 4)
,('PricingTeam', 500, 2147483647, 8)
--,('PricingTeam', 500, 2147483647, 4)
--,('Review', 500, 2147483647, 4)