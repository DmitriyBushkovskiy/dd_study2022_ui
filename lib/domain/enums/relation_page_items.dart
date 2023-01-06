enum RelationPageItemsEnum
{
    followers,
    followed,
    banned,
    requests
}

class RelationPageNamesEnum {
  static const RelationPageItemsEnum defPage = RelationPageItemsEnum.followers;

  static Map<RelationPageItemsEnum, String> pageName = {
    RelationPageItemsEnum.followers: "Followers",
    RelationPageItemsEnum.followed: "Followed",
    RelationPageItemsEnum.banned: "Banned",
    RelationPageItemsEnum.requests: "Requests",
  };
}