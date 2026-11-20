DROP TABLE IF EXISTS public.comment;
DROP TABLE IF EXISTS public.review;

CREATE TABLE public.review (
    id          SERIAL PRIMARY KEY,
    member_id   INTEGER NOT NULL,
    product_id  INTEGER NOT NULL,
    rating      INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_review_member  FOREIGN KEY (member_id)  REFERENCES public.member(id),
    CONSTRAINT fk_review_product FOREIGN KEY (product_id) REFERENCES public.product(id),
    CONSTRAINT uq_review_member_product UNIQUE (member_id, product_id)
);

CREATE INDEX idx_review_product ON public.review(product_id);

CREATE TABLE public.comment (
    id                SERIAL PRIMARY KEY,
    review_id         INTEGER NOT NULL,
    member_id         INTEGER NOT NULL,
    parent_comment_id INTEGER,   -- NULL = top-level comment, otherwise a reply
    comment_text      TEXT NOT NULL CHECK (LENGTH(TRIM(comment_text)) > 0),
    is_deleted        BOOLEAN NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_comment_review FOREIGN KEY (review_id)
        REFERENCES public.review(id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_member FOREIGN KEY (member_id)
        REFERENCES public.member(id),
    CONSTRAINT fk_comment_parent FOREIGN KEY (parent_comment_id)
        REFERENCES public.comment(id)
);

CREATE INDEX idx_comment_review ON public.comment(review_id);
CREATE INDEX idx_comment_parent ON public.comment(parent_comment_id);