drop database if exists db_metakyasshu;
create database if not exists db_metakyasshu;
use db_metakyasshu;

drop table if exists tbl_user;
create table if not exists tbl_user (
    pkUser int not null auto_increment,
    nameUser varchar(255) not null,
    emailUser varchar(255) not null,
    passwordUser varchar(255) not null,
    cpfUser varchar(255) not null,
    imageUser blob,
    dateCreateUser date not null,
    keyUser varchar(20) not null,
    confirmedUser boolean not null default false,


    constraint pk_user primary key (pkUser),
    constraint uk_emailUser unique (emailUser),
    constraint uk_cpfUser unique (cpfUser),
    constraint uk_keyUser unique (keyUser),

    index idx_pkUser (pkUser),
    index idx_emailUser (emailUser),
    index idx_cpfUser (cpfUser)
);

drop table if exists tbl_guest;
create table if not exists tbl_guest (
    pkGuest int not null auto_increment,
    accessLevelGuest enum ('SPOUSE', 'RESIDENT', 'COLLABORATOR', 'PRIVATE') not null,
    codeGuest varchar(20) not null,
    acceptDateGuest date,
    fkUserGuest int not null,
    fkUserHost int not null,

    constraint pk_guest primary key (pkGuest),
    constraint fk_user_guest foreign key (fkUserGuest)
        references tbl_user (pkUser),
    constraint fk_user_host foreign key (fkUserHost)
        references tbl_user (pkUser),

    index idx_pkGuest (pkGuest),
    index idx_fkUserGuest (fkUserGuest),
    index idx_fkUserHost (fkUserHost)
);

drop table if exists tbl_invitation;
create table if not exists tbl_invitation (
    pkInvitation int not null auto_increment,
    codeInvitation varchar(255) not null,
    sendDateInvitation date not null,
    acceptanceDateInvitation date,
    fkGuest int not null,

    constraint pk_invitation primary key (pkInvitation),
    constraint uk_code_invitation unique (codeInvitation),
    constraint fk_guest_invitation foreign key (fkGuest)
        references tbl_guest (pkGuest),
    constraint uk_fkGuest unique (fkGuest),

    index idx_pkInvitation (pkInvitation),
    index idx_codeInvitation (codeInvitation),
    index idx_fkGuest (fkGuest)
);

drop table if exists tbl_card;
create table if not exists tbl_card (
    pkCard int not null auto_increment,
    nameCard varchar(255),
    cardNumber varchar(255) not null,
    cardValidate date not null,
    typeCard enum ('CREDIT', 'DEBIT', 'DEBIT_CREDIT') not null,
    fkUser int not null,

    constraint pk_card primary key (pkCard),
    constraint uk_cardNumber unique (cardNumber),

    index idx_pkCard (pkCard),
    index idx_nameCard (nameCard)
);

drop table if exists tbl_category;
create table if not exists tbl_category (
    pkCategory int not null auto_increment,
    nameCategory varchar(255) not null,
    imageCategory blob,
    typeCategory enum ('FOOD', 'HOUSING', 'TRANSPORTATION', 'HEALTH', 'EDUCATION', 'ENTERTAINMENT', 'UTILITIES', 'CLOTHING', 'OTHERS') not null,

    constraint pk_category primary key (pkCategory),
    constraint uk_name_category unique (nameCategory),

    index idx_pkCategory (pkCategory),
    index idx_nameCategory (nameCategory)
);

drop table if exists tbl_category_user;
create table if not exists tbl_category_user (
    pkCategoryUser int not null auto_increment,
    fkCategory int not null,
    fkUser int not null,

    constraint pk_category_user primary key (pkCategoryUser),
    constraint fk_category_category_user foreign key (fkCategory)
        references tbl_category (pkCategory),
    constraint fk_user_category_user foreign key (fkUser)
        references tbl_user (pkUser),

    index idx_pkCategoryUser (pkCategoryUser),
    index idx_fkCategoryCategoryUser (fkCategory),
    index idx_fkUserCategoryUser (fkUser)
);

drop table if exists tbl_expense;
create table if not exists tbl_expense (
    pkExpense int not null auto_increment,
    nameExpense varchar(255) not null,
    descriptionExpense varchar(255) not null,
    valueExpense decimal(10, 2) not null,
    valuePayExpense decimal(10, 2) not null,
    dateExpense date not null,
    datePayExpense date not null,
    typeExpense enum ('pix', 'card', 'bill', 'booklet') not null,
    parcelExpense int not null,
    accessLevelExpense enum ('SPOUSE', 'RESIDENT', 'COLLABORATOR', 'PRIVATE') not null,
    fkUser int not null,
    fkCategory int not null,
    fkCard int not null,

    constraint pk_expense primary key (pkExpense),
    constraint fk_user_expense foreign key (fkUser) references tbl_user (pkUser),
    constraint fk_category_expense foreign key (fkCategory) references tbl_category (pkCategory),
    constraint fk_card_expense foreign key (fkCard) references tbl_card (pkCard),

    index idx_pkExpense (pkExpense),
    index idx_fkUserExpense (fkUser),
    index idx_fkCategoryExpense (fkCategory),
    index idx_fkCardExpense (fkCard)
);

drop table if exists tbl_payment;
create table if not exists tbl_payment (
    pkPayment int not null auto_increment,
    valuePayment decimal(10, 2) not null,
    datePayment date not null,
    barCodePayment varchar(50),
    parcelPayment int,
    pixPayment varchar(50),
    fkExpense int not null,
    fkCard int,

    constraint pk_payment primary key (pkPayment),
    constraint uk_expense_payment unique (fkExpense),
    constraint fk_expense_payment foreign key (fkExpense)
        references tbl_expense (pkExpense),
    constraint fk_card_payment foreign key (fkCard)
        references tbl_card (pkCard),

    index idx_pkPayment (pkPayment),
    index idx_fkExpense (fkExpense)
);

drop table if exists tbl_goal;
create table if not exists tbl_goal (
    pkGoal int not null auto_increment,
    nameGoal varchar(255) not null,
    descriptionGoal varchar(255) not null,
    valueGoal decimal(10, 2) not null,
    valuePayGoal decimal(10, 2) not null,
    coinGoal varchar(50),
    accessLevelGoal enum ('SPOUSE', 'RESIDENT', 'COLLABORATOR', 'PRIVATE') not null,
    availabilityGoal boolean not null,
    expirationDateGoal date,
    dateCreatedGoal date not null,
    dateExecutionGoal date,
    fkCategory int not null,
    fkUser int not null,

    constraint pk_goal primary key (pkGoal),
    constraint fk_category_goal foreign key (fkCategory)
        references tbl_category (pkCategory),
    constraint fk_user_goal foreign key (fkUser)
        references tbl_user (pkUser),

    index idx_pkGoal (pkGoal),
    index idx_nameGoal (nameGoal),
    index idx_fkCategory (fkCategory),
    index idx_fkUser (fkUser)
);

drop table if exists tbl_participation;
create table if not exists tbl_participation (
    pkParticipation int not null auto_increment,
    activeParticipation boolean not null,
    valueParticipation decimal(10, 2) not null,
    percentParticipation float not null,
    paidParticipation boolean not null,
    fkExpense int,
    fkGoal int,
    fkGuest int not null,

    constraint pk_participation primary key (pkParticipation),
    constraint fk_guest_participation foreign key (fkGuest)
        references tbl_guest (pkGuest),
    constraint fk_goal_participation foreign key (fkGoal)
        references tbl_goal (pkGoal),
    constraint fk_expense_participation foreign key (fkExpense)
        references tbl_expense (pkExpense),

    index idx_pkParticipation (pkParticipation),
    index idx_fkGuest (fkGuest),
    index idx_fkGoal (fkGoal),
    index idx_fkExpenseParticipation (fkExpense)
);

create table if not exists tbl_balance (
    pkBalance int not null auto_increment,
    valueBalance decimal(10, 2) not null,
    dateBalance date not null,
    fkUser int not null,

    constraint pk_balance primary key (pkBalance),
    constraint fk_user_balance foreign key (fkUser)
        references tbl_user (pkUser),

    index idx_pkBalance (pkBalance),
    index idx_fkUserBalance (fkUser)
);
